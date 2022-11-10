Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6DD6246D2
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiKJQYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKJQYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:24:46 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0D625C3
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:24:46 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y203so2656881pfb.4
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WcMoIuzERReXkNIiGnXAzD6h4jC6olJQLjpcLn6f5Sc=;
        b=NshAAGjbOWp2UaqB8yHIDc79FeUgA3+ARWkKcBBymxThMtu6ZEdv1EZtSczjZEBUvx
         byGzK/Z5yaMCb+kt6Z3rcTecuNB9ZlAq2HKImDcRRN6prrOcTvKioth47J7L6l3f+oEH
         QI4krkfeWg+5GU/8Mgnwg+DMg1g7TwuCaHki6dsyVQK/IpdZC4osFmJmQV4qPFbTdFgi
         03uRKfCOnKag9zE1sHsnc2LbrVzflfQAZV92+/5UPRc+q8DW+x8opYnO/T9Z2CYtn+wv
         h81oZhI8y3FBBFw9lB0lT+9V8q4bpXyCw9GflMU3rEV/5v7/sAI3Mv2i3l9V4fmLSUJZ
         aEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcMoIuzERReXkNIiGnXAzD6h4jC6olJQLjpcLn6f5Sc=;
        b=Zbpamlq8+Bi/+MRGUXO22DSaQBA0wd967jJ3V5Qd8LLf1kTcQ9tz7/TXPiVJMOggBt
         CtE/t3MiRdw7WT4yDGLMq2knuInLHXcaR2S6ZU3JxeCG4Wnd9dcy2Y9slgOK7lXpK3Pl
         smYiqpBVYObWGJ0a9wmv8tEQ74+sNZHkmkLX36TxbIsCxa1be6DhZAYoxWlITX/bcLmU
         HOyy0sIw2yjK1fMnf7ESZOjbY3dPUjY0xmQr4n46Nsz36LzOKAeBfsVhibroAdXPBOC8
         qTsqRmtQM/xfeTNonaoJfT4a5v7d2nhYj/YrPgxVtwTDUkQtQswezWVRHjuGkbQARW3S
         Wkvg==
X-Gm-Message-State: ACrzQf16Kru6Jth5uh1f937fKTQu8S9A3fNC3JRVhwpptzXtabOEQQVF
        JPBhV6VWgGHCX+VZrL8XT8K5YA==
X-Google-Smtp-Source: AMsMyM4sjlTERLuDr34bKS3XJQZnGMKmSIsHN7pN4gYnwG7sfGxHrUaLK08YhR6C4iMcmDzCIYGCMA==
X-Received: by 2002:a62:5e06:0:b0:56b:e3f8:824f with SMTP id s6-20020a625e06000000b0056be3f8824fmr65425089pfb.84.1668097485605;
        Thu, 10 Nov 2022 08:24:45 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w13-20020a1709027b8d00b00186c5e8b1d0sm11331800pll.149.2022.11.10.08.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:24:45 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:24:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
        kevin.tian@intel.com
Subject: Re: [RESEND PATCH 4/6] x86/traps: add external_interrupt() to
 dispatch external interrupts
Message-ID: <Y20lyBl67GDZVOeB@google.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-5-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110061545.1531-5-xin3.li@intel.com>
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

On Wed, Nov 09, 2022, Xin Li wrote:
> +__visible noinstr void external_interrupt(struct pt_regs *regs,
> +					  unsigned int vector)
> +{
> +	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
> +
> +	BUG_ON(vector < FIRST_EXTERNAL_VECTOR);

Why not return an error up the stack?  KVM and/or CPU bugs aren't unheard of.
Dropping an IRQ obviously isn't ideal, but there's a non-zero chance that letting
KVM WARN and kill the VM will keep the host alive and thus other VMs running.  A
somewhat sophisticated setup might even react to the VM being killed by migrating
other VMs off the system and initiating host maintenance.
