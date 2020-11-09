Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED52AB414
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgKIJ4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:56:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:58746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgKIJ4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 04:56:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 76D70ABCC;
        Mon,  9 Nov 2020 09:56:29 +0000 (UTC)
Subject: Re: [PATCH 2/3] accel/stubs: Restrict system-mode emulation stubs
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org
References: <20201109094547.2456385-1-f4bug@amsat.org>
 <20201109094547.2456385-3-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <552db7b0-78da-7f5c-065f-c82b6a296852@suse.de>
Date:   Mon, 9 Nov 2020 10:56:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201109094547.2456385-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/20 10:45 AM, Philippe Mathieu-Daudé wrote:
> This system-mode emulation stubs are not require

nit: s,require,required,

> in user-mode binaries. Restrict them to system-mode
> binaries.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  accel/stubs/meson.build | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/accel/stubs/meson.build b/accel/stubs/meson.build
> index 12dd1539afa..a83408bc0a7 100644
> --- a/accel/stubs/meson.build
> +++ b/accel/stubs/meson.build
> @@ -1,4 +1,8 @@
> -specific_ss.add(when: 'CONFIG_HAX', if_false: files('hax-stub.c'))
> -specific_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
> -specific_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
> -specific_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
> +accel_stubs_ss = ss.source_set()
> +
> +accel_stubs_ss.add(when: 'CONFIG_HAX', if_false: files('hax-stub.c'))
> +accel_stubs_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
> +accel_stubs_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
> +accel_stubs_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
> +
> +specific_ss.add_all(when: ['CONFIG_SOFTMMU'], if_true: accel_stubs_ss)
> 

