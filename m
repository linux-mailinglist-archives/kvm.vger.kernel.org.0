Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED887B64C6
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbjJCI50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbjJCI5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:57:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02523A9
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 01:57:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 33B3F1F893;
        Tue,  3 Oct 2023 08:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696323436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YbIvpO+nBUD9kLhZtb3pxE3oHjEwKfLWaARI6nsRjd8=;
        b=wJTXJwTeQKpoHqtgzBHtpXGK6m4fA+VqIQGQFnOcZIayRmVX+rPmRHEJKoLnHfmn1+cIN2
        p+oo9ADWM/ZT5yWfllpitnKf3FlchlI68NrRfTTuYxjSHA9lngJIB/OS8ZVx4lhyK/sEs4
        YJoL036zbBgLSy1tioILH7sgU9zwrRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696323436;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YbIvpO+nBUD9kLhZtb3pxE3oHjEwKfLWaARI6nsRjd8=;
        b=8aqAiFV7V3q76p1194dee67oegA+5pKd3wjx/jMSFUXYewEg4osceikWimSYP2Qny0FrVO
        M/pfwkp1WlKNyQDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BB62A139F9;
        Tue,  3 Oct 2023 08:57:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +JuAK2vXG2VaPwAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 03 Oct 2023 08:57:15 +0000
Message-ID: <f30edf1b-5fd5-4ea6-8e23-097365c30c7a@suse.de>
Date:   Tue, 3 Oct 2023 10:57:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 4/5] accel/tcg: Have tcg_exec_realizefn() return a boolean
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230915190009.68404-1-philmd@linaro.org>
 <20230915190009.68404-5-philmd@linaro.org>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20230915190009.68404-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/23 21:00, Philippe Mathieu-Daudé wrote:
> Following the example documented since commit e3fe3988d7 ("error:
> Document Error API usage rules"), have tcg_exec_realizefn() return
> a boolean indicating whether an error is set or not.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Claudio Fontana <cfontana@suse.de>

> ---
>  include/exec/cpu-all.h | 2 +-
>  accel/tcg/cpu-exec.c   | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index c2c62160c6..1e5c530ee1 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -422,7 +422,7 @@ void dump_exec_info(GString *buf);
>  
>  /* accel/tcg/cpu-exec.c */
>  int cpu_exec(CPUState *cpu);
> -void tcg_exec_realizefn(CPUState *cpu, Error **errp);
> +bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
>  void tcg_exec_unrealizefn(CPUState *cpu);
>  
>  /**
> diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
> index e2c494e75e..fa97e9f191 100644
> --- a/accel/tcg/cpu-exec.c
> +++ b/accel/tcg/cpu-exec.c
> @@ -1088,7 +1088,7 @@ int cpu_exec(CPUState *cpu)
>      return ret;
>  }
>  
> -void tcg_exec_realizefn(CPUState *cpu, Error **errp)
> +bool tcg_exec_realizefn(CPUState *cpu, Error **errp)
>  {
>      static bool tcg_target_initialized;
>      CPUClass *cc = CPU_GET_CLASS(cpu);
> @@ -1104,6 +1104,8 @@ void tcg_exec_realizefn(CPUState *cpu, Error **errp)
>      tcg_iommu_init_notifier_list(cpu);
>  #endif /* !CONFIG_USER_ONLY */
>      /* qemu_plugin_vcpu_init_hook delayed until cpu_index assigned. */
> +
> +    return true;
>  }
>  
>  /* undo the initializations in reverse order */

