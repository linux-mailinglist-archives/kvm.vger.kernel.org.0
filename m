Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5310C5DF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfK1JW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:22:29 -0500
Received: from mga05.intel.com ([192.55.52.43]:31911 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfK1JW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 04:22:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Nov 2019 01:22:29 -0800
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="203380662"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Nov 2019 01:22:26 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/13] samples: vfio-mdev: constify fb ops
In-Reply-To: <20191127182940.GM406127@phenom.ffwll.local>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1574871797.git.jani.nikula@intel.com> <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com> <20191127182940.GM406127@phenom.ffwll.local>
Date:   Thu, 28 Nov 2019 11:22:23 +0200
Message-ID: <87d0dcnynk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Nov 2019, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Nov 27, 2019 at 06:32:09PM +0200, Jani Nikula wrote:
>> Now that the fbops member of struct fb_info is const, we can star making
>> the ops const as well.
>> 
>> Cc: Kirti Wankhede <kwankhede@nvidia.com>
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>
> You've missed at least drivers/staging/fbtft in your search. I guess you
> need to do a full make allyesconfig on x86/arm and arm64 (the latter
> because some stupid drivers only compile there, not on arm, don't ask).
> Still misses a pile of mips/ppc only stuff and maybe the sparcs and
> alphas, but should be good enough.

fbtft dynamically allocates the fbops, for whatever reason. There were
others like that too. Some of the drivers modify the fbops runtime to
choose different hooks for different configurations. Can't change them
all anyway.

Facilitating making the fbops const is one thing (patches 1-8), but I'm
not really sure I want to sign up for exhaustively moving fbops to
rodata on anything beyond drivers/gpu/drm. It's not like I leave stuff
broken. Besides I am trying to cover all the low hanging fruit where I
can simply add the "const" and be done with it.

BR,
Jani.

>
> With that done, on the remaining patches:
>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
>> ---
>>  samples/vfio-mdev/mdpy-fb.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>> index 2719bb259653..21dbf63d6e41 100644
>> --- a/samples/vfio-mdev/mdpy-fb.c
>> +++ b/samples/vfio-mdev/mdpy-fb.c
>> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
>>  		iounmap(info->screen_base);
>>  }
>>  
>> -static struct fb_ops mdpy_fb_ops = {
>> +static const struct fb_ops mdpy_fb_ops = {
>>  	.owner		= THIS_MODULE,
>>  	.fb_destroy	= mdpy_fb_destroy,
>>  	.fb_setcolreg	= mdpy_fb_setcolreg,
>> -- 
>> 2.20.1
>> 
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Graphics Center
