Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0744168B7
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 02:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbhIXAKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 20:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243616AbhIXAKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 20:10:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3411CC061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 17:09:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t4so5150479plo.0
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 17:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rDmU+Q2B4PTbdip8cERFEgEFFT0D1k5kz4h+kRWhpfk=;
        b=SU3oAtVHe07oGmo26bqQMJMe+Q0hpLVga9WeYDmQHt++cXj3hLG+Yu5UxmVUdJ8Pnr
         ypdIByJqjemMIe4REY3hpKf1R4vMd9Mo3SDsXP2lT5chzna2/1LZaWROnjL3BY7ym6sk
         57ionAdRegLUZlVSAfjF461WQ0V05+muV7IDGUKaWU/jaHPJoUJnInB/o0BiUj/160kk
         AtYAYRKC+dRP0XxGLTC6aw0VwgLfgl6Dl7R8JC1dgH4SONPZw/gPt5jb5J5K5xMxy4/B
         N2S1gcrN8JG0eEmWjKAZUYVHwRkKB1qOvcs8ZaNuSd8E1MTPFR+T4qAYXt8g02V9OPIV
         TeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rDmU+Q2B4PTbdip8cERFEgEFFT0D1k5kz4h+kRWhpfk=;
        b=0uSPWhdy+GXWMODkvVEEwgLm3TaZemhODQtLD2K+0IDM1AVoovpnh9J1U6WT4Wehld
         HzWN4ZYONn/kIfn389c+GHIlm66X1YkNiDKJP5eUFxjgFfDl8bRNaZi70wFTarf3Uk1v
         PuAdDvyMdmkD8GjsfrKEgshkT1uAZcTU50PSp97EeWsfFmamRQtk3nxdCLfmK8MEUeSh
         rMBbAMkF9Cbp+tSAR0Jk6TvrH1v0v8PuPLC/rUlOnqpoBAQm1YfXutqX/yqrcZhi5WQr
         aLwAN1imqArFLzyve9HxAw+MLwLvKG93XosqbuHfxFQ0hZj7vpdZVZerOk9f1zRVBQbS
         QmMQ==
X-Gm-Message-State: AOAM531et7s5oqfdinjV3YepV7o75IfsrmLM/k/DtRvDbnErxVFRJcWF
        yb6nLQkbb7MdLf0pHfnA2GAdxA==
X-Google-Smtp-Source: ABdhPJwKwFjLIpgL7YxVwt8hXUT+iYGdH0WDrQ3+AV+hRzPJtyhDQOH1n4/VDpkBlA5z3IpZ7cErYg==
X-Received: by 2002:a17:902:ce83:b0:13b:67d5:2c4e with SMTP id f3-20020a170902ce8300b0013b67d52c4emr6610278plg.45.1632442150466;
        Thu, 23 Sep 2021 17:09:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 4sm6310318pjb.21.2021.09.23.17.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 17:09:09 -0700 (PDT)
Date:   Fri, 24 Sep 2021 00:09:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <YU0XIoeYpfm1Oy0j@google.com>
References: <20210923220033.4172362-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923220033.4172362-1-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021, Oliver Upton wrote:
> While x86 does not require any additional setup to use the ucall
> infrastructure, arm64 needs to set up the MMIO address used to signal a
> ucall to userspace. rseq_test does not initialize the MMIO address,
> resulting in the test spinning indefinitely.
> 
> Fix the issue by calling ucall_init() during setup.
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/rseq_test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 060538bd405a..c5e0dd664a7b 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
>  	 * CPU affinity.
>  	 */
>  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	ucall_init(vm, NULL);

Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
going to remember to add this next time I write a common selftest, arm64 is the
oddball here.
