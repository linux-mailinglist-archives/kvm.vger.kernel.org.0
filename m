Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3545127E8EB
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgI3Mug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 08:50:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:54866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3Mug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 08:50:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 29CA0AF26;
        Wed, 30 Sep 2020 12:50:35 +0000 (UTC)
Subject: Re: [PATCH v4 02/12] meson: Allow optional target/${ARCH}/Kconfig
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-3-philmd@redhat.com>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <19b1318a-f9be-5808-760b-ba7748d48267@suse.de>
Date:   Wed, 30 Sep 2020 14:50:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-3-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/30/20 12:43 AM, Philippe Mathieu-Daudé wrote:
> Extend the generic Meson script to pass optional target Kconfig
> file to the minikconf script.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> We could use fs.exists() but is_file() is more specific
> (can not be a directory).
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Claudio Fontana <cfontana@suse.de>
> ---
>  meson.build | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index d36dd085b5..9ab5d514d7 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -529,6 +529,7 @@ kconfig_external_symbols = [
>  ]
>  ignored = ['TARGET_XML_FILES', 'TARGET_ABI_DIR', 'TARGET_DIRS']
>  
> +fs = import('fs')
>  foreach target : target_dirs
>    config_target = keyval.load(meson.current_build_dir() / target / 'config-target.mak')
>  
> @@ -569,8 +570,13 @@ foreach target : target_dirs
>      endforeach
>  
>      config_devices_mak = target + '-config-devices.mak'
> +    target_kconfig = 'target' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
> +    minikconf_input = ['default-configs' / target + '.mak', 'Kconfig']
> +    if fs.is_file(target_kconfig)
> +      minikconf_input += [target_kconfig]
> +    endif
>      config_devices_mak = configure_file(
> -      input: ['default-configs' / target + '.mak', 'Kconfig'],
> +      input: minikconf_input,
>        output: config_devices_mak,
>        depfile: config_devices_mak + '.d',
>        capture: true,
> 

I can't say I understand it, but the general idea seems right to me.

Ciao,

Claudio
