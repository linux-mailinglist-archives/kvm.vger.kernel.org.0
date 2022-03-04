Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE4F4CD86C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 17:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbiCDQDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 11:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240216AbiCDQDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 11:03:03 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0619F1B45F4
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 08:02:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so8332396pjl.4
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 08:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iKXCjtCLyBd5SB18xoMWfCbBK72dJBo8wk/xWeD+1ow=;
        b=NPSSv1f3NiH3nTbPR/NPI7t4q8iZbNmkZSqGP9caRbEBz5GMNW0dupYVnfkr37GxHS
         uFRR9axd85c3A3GQCeoJhLNRGbuxmdhoAcMDmoyqJzz2oRZCQw6e1paiySPVS6maVjPJ
         z56hr2HqCwbGSKMjr8VVTO57uRlOcFK9ZcpG95v5Tnja6WV6VrdtZVr170asTMeevLmD
         dDtqEFxoENq2TJp1f5ug93p6pcYTrMrhkjT800eDh4d93ZQ9VZh3mQIF6gNoy8KEEmTN
         BZfTAleX/3o18B5/t/PuP1d2ULiF0mSXHp2xD9T37gcWn6coO+NCArTWDz15iq/fuwLO
         CqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKXCjtCLyBd5SB18xoMWfCbBK72dJBo8wk/xWeD+1ow=;
        b=MftVYl5dN3UTP2UzaTNPBplwlsFoQ1OLvsEcc/o9t5N0P6ZVp+cKrCkreDfP1ukMmb
         pByuvuT72v1fRAOsgtgqCEE7boaVMdviGXS9hYooRHyW1+idZf+oGlJm9WUKyRbCn7fa
         IpVCMO84lSNbz2fA8t26ElBRvJEqZW05ldBqTZHE/bEB7qubUQ7FVKCyAVOLIEo0B0dL
         RCogFovdQNsUIDCKqo/9varp0PTtB51qq57sqxfljpG2jDrXcV/2GeakgqVxMAjb13NE
         +VI/QSHqNVgLYV2xdlGQ3ngpKgqtW27QYIVYrhJENtfkVUtJtwQlbTt82wYw4asF/YDe
         JMpA==
X-Gm-Message-State: AOAM5330L5vhQ7PUNmMCwU+EwJMcQt/TrGRyyoiayyDw8JwGaPa2/EsM
        GswwmBbQsoiv9HjwATL4DfHvJvxh/DmkkA==
X-Google-Smtp-Source: ABdhPJzeXnsVXGYYR1+7nVhiTHXCnWwr/9Bmg9y2srKh/JAflfqdxZMKubdlTRKrOS03r16N1ZvbBw==
X-Received: by 2002:a17:902:6841:b0:150:9b8c:3a67 with SMTP id f1-20020a170902684100b001509b8c3a67mr36997799pln.151.1646409735126;
        Fri, 04 Mar 2022 08:02:15 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 66-20020a620445000000b004f6c30d84cfsm1641711pfe.155.2022.03.04.08.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 08:02:14 -0800 (PST)
Date:   Fri, 4 Mar 2022 16:02:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YiI4AmYkm2oiuiio@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
 <YiExLB3O2byI4Xdu@google.com>
 <YiEz3D18wEn8lcEq@google.com>
 <eeac12f0-0a18-8c63-1987-494a2032fa9d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeac12f0-0a18-8c63-1987-494a2032fa9d@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> On 3/3/22 22:32, Sean Christopherson wrote:
> I didn't remove the paragraph from the commit message, but I think it's
> unnecessary now.  The workqueue is flushed in kvm_mmu_zap_all_fast() and
> kvm_mmu_uninit_tdp_mmu(), unlike the buggy patch, so it doesn't need to take
> a reference to the VM.
> 
> I think I don't even need to check kvm->users_count in the defunct root
> case, as long as kvm_mmu_uninit_tdp_mmu() flushes and destroys the workqueue
> before it checks that the lists are empty.

Yes, that should work.  IIRC, the WARN_ONs will tell us/you quite quickly if
we're wrong :-)  mmu_notifier_unregister() will call the "slow" kvm_mmu_zap_all()
and thus ensure all non-root pages zapped, but "leaking" a worker will trigger
the WARN_ON that there are no roots on the list.
