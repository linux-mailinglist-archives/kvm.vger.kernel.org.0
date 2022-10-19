Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32671604C30
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiJSPvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiJSPvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:51:15 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5785172537
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:47:05 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s30so25898011eds.1
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QpxLQA9XPUewEHX/45h//HdR2yIq/tEj/1YezYLDX0=;
        b=OWfE59Lm25mCNlUki8tYQIpUSzerqalC7O2lwMJbqbJNcMshIS0djoedpTUK3TZSk5
         vjtbeWT1tsd30RniseB4tzfWIOdzRkhXri/Wn8EkdKlObaRi32pCsC5okls3TNRRZ6AY
         D6TjFM3rivU1wrjwvfpg5wwk1aJoE0AR5fKN+FZsbFhQgBiGqBfZcPVGw3ATORhJPFKo
         KmTOY9vsP8q1F3KG1iaxKlnX086MmeaF/+96jCElljjEUU8MZ2Wn0thjnPKz/d3+Lytd
         SQkcVPoAXkb0N0WsnuXEtW7sar/4IfozdyR1MBF3TUR2WoXft7UPyzke5wzbYTuvrbtV
         cwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QpxLQA9XPUewEHX/45h//HdR2yIq/tEj/1YezYLDX0=;
        b=MBrTzOWdW1vTv4y/rfNik8p+5tTZMoAbWFnpxQXsvWSYNTvp3nA9PeOZ1bCnfM02g5
         ZFosdpQCGuYain2Fw2sYo+LthmDSSpnaJADKURrZ0DQ2uOM6SgT17YjfIXho9HLaVdVS
         02KOIHaVfDaHyR2jD+9KpK7NnK+qqtjriMdUfgrF8ZC11o70uJq1n/8tvYsH9MEYhy3x
         aOzsDht+Kbzey07PmibIP2eKFRmxLrApJAgefgOzqtnOzVL5DEROpZhb0sYxVM4wQJek
         u1kIh8ORvOA3NN+3kp8fKYyUMf/Bj0PZCkQrAGN7uR8pB+9q7suXAT1fCFYg0KUV+pk/
         BX8g==
X-Gm-Message-State: ACrzQf1Vopb0VvFeluhvXy0v+yYDcrMR4FqxLjDPvmRn6CbjbKLyDdrP
        TBvwZD4/6RubTTBr2tZqoNt8Wg==
X-Google-Smtp-Source: AMsMyM6AYcdOgw2iQ49E1qfbw3hHt9myuk+HR8W4QyF6ds15StyGev6O3Li7L6vCvN9o9x7j74tUgg==
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id eq9-20020a056402298900b0044e90d0b9ffmr8039042edb.110.1666194401367;
        Wed, 19 Oct 2022 08:46:41 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id p5-20020a170906498500b0078b83968ad4sm9075070eju.24.2022.10.19.08.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:46:40 -0700 (PDT)
Date:   Wed, 19 Oct 2022 15:46:37 +0000
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 13/25] KVM: arm64: Instantiate pKVM hypervisor VM and
 vCPU structures from EL1
Message-ID: <Y1Ab3cxaVtqTBBo7@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-14-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-14-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday 17 Oct 2022 at 12:51:57 (+0100), Will Deacon wrote:
> +struct kvm_protected_vm {
> +	pkvm_handle_t handle;
> +	struct mutex vm_lock;
> +
> +	struct {
> +		void *pgd;
> +		void *vm;
> +		void *vcpus[KVM_MAX_VCPUS];

That's memory that's 'wasted' for everyone :/

> +	} hyp_donations;
> +};
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -170,10 +181,10 @@ struct kvm_arch {
>  	struct kvm_smccc_features smccc_feat;
>  
>  	/*
> -	 * For an untrusted host VM, 'pkvm_handle' is used to lookup
> +	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
> -	pkvm_handle_t pkvm_handle;
> +	struct kvm_protected_vm pkvm;

Maybe make this a pointer that will be !NULL only when pKVM is enabled?

>  };
