Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847F369D252
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 18:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBTRr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 12:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjBTRry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 12:47:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D896E1DB8F
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 09:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676915210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hWZIjcrYwrJWS0SnFQ4J1tbY58nVFYJ+Qq2znZbe+pI=;
        b=igsGrKE11HJyPFLOLGLeu+FLtzHZAP2DpGI21PisDrwRElpUeqwDuyK1O3i5J30wnE+Ztd
        nujf6sFwIdkncUodLnSlBy7X2dNiyFQYWNS/TIZnUtfigHRAnEcsXDCceTgoHIpqKLAUOt
        lnxfSJ/pzjFnTWM3DPa6/4VAbv1Sjwc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-583-7y_oydXIOmOH8_te0x_w-w-1; Mon, 20 Feb 2023 12:46:41 -0500
X-MC-Unique: 7y_oydXIOmOH8_te0x_w-w-1
Received: by mail-ed1-f72.google.com with SMTP id ee6-20020a056402290600b004ad51f8fc36so2257436edb.22
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 09:46:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWZIjcrYwrJWS0SnFQ4J1tbY58nVFYJ+Qq2znZbe+pI=;
        b=ip1ghE1/8vQ/0XW5555A7aVSFTCCtZqFO+RbvoQLJMpz+vJ2BfsewgrfddRaqr7hlH
         YOONDv81gFhyXJzijBDE9ZxI5WPNyz+PkEyDsyE/SxRMIKpm1qRn+3wyblA28vzxMluT
         mOdQvqzpVZNtaP1lBKHjTID229EjC7tMaOKHGkJT/eabR92yqeo6r/GYglZCLWb7uhEI
         mZEudwUUFQ6dXKlhzW/7BGN9y2pg58h1XUAbu0obevh4rHczdcrhjRrAL4Dmvrx3j005
         1HluxLWPKBcn0Edo1KMtAIutJCg3UQ90fCcciE8DRvrMSyTpTAyiG744o0c82jeHRR11
         7yvQ==
X-Gm-Message-State: AO0yUKUZGShdCEtzC1isbwe+KkA7wgFHGfZgqY5lRMVAB8Fd83/F0k9/
        JshLCn3MNy4T3ahxkRoyn48fZEJZ41WUcCXRDJQE8b7ldPCO2BQ2oR991UdjfRf+zskLtMKDcRh
        7AaLP6crZQlEp
X-Received: by 2002:a17:906:c55:b0:8b1:7dea:cc40 with SMTP id t21-20020a1709060c5500b008b17deacc40mr13014038ejf.9.1676915200203;
        Mon, 20 Feb 2023 09:46:40 -0800 (PST)
X-Google-Smtp-Source: AK7set/4M5AqthPWPDaHqd+T/52TERaZwpNY5aFMq33k0a6rEitA+IBF394l4ksyh+KMrx6UqRgCxQ==
X-Received: by 2002:a17:906:c55:b0:8b1:7dea:cc40 with SMTP id t21-20020a1709060c5500b008b17deacc40mr13014024ejf.9.1676915199884;
        Mon, 20 Feb 2023 09:46:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id m18-20020a17090607d200b008d044ede804sm1872252ejc.163.2023.02.20.09.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 09:46:39 -0800 (PST)
Message-ID: <4c501e8e-6981-814e-4fec-71a56363711b@redhat.com>
Date:   Mon, 20 Feb 2023 18:46:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-9-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 08/29] LoongArch: KVM: Implement vcpu handle exit
 interface
In-Reply-To: <20230220065735.1282809-9-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 07:57, Tianrui Zhao wrote:
> +	if (ret == RESUME_GUEST)
> +		kvm_acquire_timer(vcpu);
> +
> +	if (!(ret & RESUME_HOST)) {
> +		_kvm_deliver_intr(vcpu);
> +		/* Only check for signals if not already exiting to userspace */
> +		if (signal_pending(current)) {
> +			run->exit_reason = KVM_EXIT_INTR;
> +			ret = (-EINTR << 2) | RESUME_HOST;
> +			++vcpu->stat.signal_exits;
> +			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_SIGNAL);
> +		}
> +	}
> +
> +	if (ret == RESUME_GUEST) {
> +		trace_kvm_reenter(vcpu);
> +
> +		/*
> +		 * Make sure the read of VCPU requests in vcpu_reenter()
> +		 * callback is not reordered ahead of the write to vcpu->mode,
> +		 * or we could miss a TLB flush request while the requester sees
> +		 * the VCPU as outside of guest mode and not needing an IPI.
> +		 */
> +		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> +
> +		cpu = smp_processor_id();
> +		_kvm_check_requests(vcpu, cpu);
> +		_kvm_check_vmid(vcpu, cpu);
> +		vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
> +
> +		/*
> +		 * If FPU are enabled (i.e. the guest's FPU context
> +		 * is live), restore FCSR0.
> +		 */
> +		if (_kvm_guest_has_fpu(&vcpu->arch) &&
> +			read_csr_euen() & (CSR_EUEN_FPEN)) {
> +			kvm_restore_fcsr(&vcpu->arch.fpu);
> +		}
> +	}

Please avoid copying code from arch/mips/kvm since it's already pretty ugly.

