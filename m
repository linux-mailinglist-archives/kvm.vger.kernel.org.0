Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E267B64D9
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbjJCI7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjJCI7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:59:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6160EB3
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 01:58:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1DC3B1F893;
        Tue,  3 Oct 2023 08:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696323536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FzeosV5o+VBicvMZZcvFgmf0xeDEQXO35zpf3Fl90nE=;
        b=wxZjcALKmtoMqn6hcvqLrnHSA7zwnj26Fgs1b3IXdN/6c4DMRy6jZv4ViLdQCfPent25d3
        cwsfaI77Vs4G6v0Un1q9QYZiGJp6Q2UDC/KzUQ9/MDkEVXI6V5hzYcH0eRM3CKvTz7K1JL
        oYT2tjto14fM15AbenC88Waf9KtDe7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696323536;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FzeosV5o+VBicvMZZcvFgmf0xeDEQXO35zpf3Fl90nE=;
        b=0t42XBH9cZyfQOjH7qNkgbFOo9pQYbohpFDvTy5CzW1hdRDzwGVwZc5rv26iOvXhHp2GQx
        xDUoeYH6K3ujsTAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AB7A8139F9;
        Tue,  3 Oct 2023 08:58:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ahS3J8/XG2UMQAAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 03 Oct 2023 08:58:55 +0000
Message-ID: <0049dc3b-df77-1c2f-b971-5a9d13382059@suse.de>
Date:   Tue, 3 Oct 2023 10:58:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5/5] accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG
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
 <20230915190009.68404-6-philmd@linaro.org>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20230915190009.68404-6-philmd@linaro.org>
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
> We don't need to expose these TCG-specific methods to the
> whole code base. Register them as AccelClass handlers, they
> will be called by the generic accel_cpu_[un]realize() methods.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Claudio Fontana <cfontana@suse.de>

> ---
>  accel/tcg/internal.h   | 3 +++
>  include/exec/cpu-all.h | 2 --
>  accel/tcg/tcg-all.c    | 2 ++
>  cpu.c                  | 8 --------
>  4 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/accel/tcg/internal.h b/accel/tcg/internal.h
> index e8cbbde581..57ab397df1 100644
> --- a/accel/tcg/internal.h
> +++ b/accel/tcg/internal.h
> @@ -80,6 +80,9 @@ bool tb_invalidate_phys_page_unwind(tb_page_addr_t addr, uintptr_t pc);
>  void cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
>                                 uintptr_t host_pc);
>  
> +bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
> +void tcg_exec_unrealizefn(CPUState *cpu);
> +
>  /* Return the current PC from CPU, which may be cached in TB. */
>  static inline vaddr log_pc(CPUState *cpu, const TranslationBlock *tb)
>  {
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index 1e5c530ee1..230525ebf7 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -422,8 +422,6 @@ void dump_exec_info(GString *buf);
>  
>  /* accel/tcg/cpu-exec.c */
>  int cpu_exec(CPUState *cpu);
> -bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
> -void tcg_exec_unrealizefn(CPUState *cpu);
>  
>  /**
>   * cpu_set_cpustate_pointers(cpu)
> diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
> index 03dfd67e9e..6942a9766a 100644
> --- a/accel/tcg/tcg-all.c
> +++ b/accel/tcg/tcg-all.c
> @@ -227,6 +227,8 @@ static void tcg_accel_class_init(ObjectClass *oc, void *data)
>      AccelClass *ac = ACCEL_CLASS(oc);
>      ac->name = "tcg";
>      ac->init_machine = tcg_init_machine;
> +    ac->realize_cpu = tcg_exec_realizefn;
> +    ac->unrealize_cpu = tcg_exec_unrealizefn;
>      ac->allowed = &tcg_allowed;
>      ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
>  
> diff --git a/cpu.c b/cpu.c
> index b928bbed50..1a8e730bed 100644
> --- a/cpu.c
> +++ b/cpu.c
> @@ -140,11 +140,6 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
>          return;
>      }
>  
> -    /* NB: errp parameter is unused currently */
> -    if (tcg_enabled()) {
> -        tcg_exec_realizefn(cpu, errp);
> -    }
> -
>      /* Wait until cpu initialization complete before exposing cpu. */
>      cpu_list_add(cpu);
>  
> @@ -190,9 +185,6 @@ void cpu_exec_unrealizefn(CPUState *cpu)
>       * accel_cpu_unrealize, which may free fields using call_rcu.
>       */
>      accel_cpu_unrealize(cpu);
> -    if (tcg_enabled()) {
> -        tcg_exec_unrealizefn(cpu);
> -    }
>  }
>  
>  /*

