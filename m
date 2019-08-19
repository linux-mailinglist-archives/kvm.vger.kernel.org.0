Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61C94958
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 18:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfHSQDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 12:03:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfHSQDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 12:03:05 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD72281DF1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 16:03:04 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id m7so5116618wrw.22
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 09:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7aRRIQCBlZS2kbOILqbS6uNDsuRxF1J0G9vXCUGlVhQ=;
        b=XETFsZ/O6fzd7c5q6d3ZT4Bx+Z8Lh8ReiStcx95LUv+Az3XKqZ7svNA6rXlgm3ME/e
         6xrRDTIznqWDItgXRywa5GLHnDEW7xfop5bwDPAYE8/mLYcgcX0BHW+K5zUnYtgkEzVG
         MIn6by1BwM3HI5VxE6zt5sjdLfgyOCt41LgAuyL1t4iYrWWaw6zZYtFqoOP+NMEgX81X
         5qgwwXoK69UbmolCvoEROsC/eiWSaN/O0nUzif5bdjkBRFnXQ0rgyN3Lh1s/yJLs6D+3
         LkMFXUyqm2MKHjkq1fKM908KxBMfXKGNqJ53mntKWvcEP3NxFjmxtw1uOvVwcIKlMYUP
         eYBQ==
X-Gm-Message-State: APjAAAVpe9ZqCwZ6rWgOBPTDX5/yHrWcXktrTQnZ8GW7PsPa6p534FHJ
        NhV+uP3zIbBEaBaCwn9+Dv9cvOhzlDksz/ErJLVs9muX7XzrxjBcYQmPfYZpGuPK/v6UblM2/wC
        36FptzArDwriy
X-Received: by 2002:adf:ea51:: with SMTP id j17mr30709798wrn.184.1566230583043;
        Mon, 19 Aug 2019 09:03:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwHHdY3aOS7C59wQWPwRLlcYs2FDVDgPURi3rxDWHM0bcfybGoPfN1BfDOw7n0uUzQ0XXienw==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr30709765wrn.184.1566230582743;
        Mon, 19 Aug 2019 09:03:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id z12sm5466721wrt.92.2019.08.19.09.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 09:03:02 -0700 (PDT)
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
To:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home> <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home> <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com> <20190815092324.46bb3ac1@x1.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
Date:   Mon, 19 Aug 2019 18:03:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815092324.46bb3ac1@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/08/19 17:23, Alex Williamson wrote:
> 0xffe00
> 0xfee00
> 0xfec00
> 0xc1000
> 0x80a000
> 0x800000
> 0x100000
> 
> ie. I can effective only say that sp->gfn values of 0x0, 0x40000, and
> 0x80000 can take the continue branch without seeing bad behavior in the
> VM.
> 
> The assigned GPU has BARs at GPAs:
> 
> 0xc0000000-0xc0ffffff
> 0x800000000-0x808000000
> 0x808000000-0x809ffffff
> 
> And the assigned companion audio function is at GPA:
> 
> 0xc1080000-0xc1083fff
> 
> Only one of those seems to align very well with a gfn base involved
> here.  The virtio ethernet has an mmio range at GPA 0x80a000000,
> otherwise I don't find any other I/O devices coincident with the gfns
> above.

The IOAPIC and LAPIC are respectively gfn 0xfec00 and 0xfee00.  The
audio function BAR is only 16 KiB, so the 2 MiB PDE starting at 0xc1000
includes both userspace-MMIO and device-MMIO memory.  The virtio-net BAR
is also userspace-MMIO.

It seems like the problem occurs when the sp->gfn you "continue over"
includes a userspace-MMIO gfn.  But since I have no better ideas right
now, I'm going to apply the revert (we don't know for sure that it only
happens with assigned devices).

Paolo

> I'm running the VM with 2MB hugepages, but I believe the issue still
> occurs with standard pages.  When run with standard pages I see more
> hits to gfn values 0, 0x40000, 0x80000, but the same number of hits to
> the set above that cannot take the continue branch.  I don't know if
> that means anything.
> 
> Any further ideas what to look for?  Thanks,
> 
> Alex
> 
> PS - I see the posted workaround patch, I'll test that in the interim.
> 

