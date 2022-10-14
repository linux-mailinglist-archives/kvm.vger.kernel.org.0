Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41665FEBB7
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 11:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiJNJeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 05:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJNJeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 05:34:02 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BA3109D46
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 02:34:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b2so4233740plc.7
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 02:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qzAcxQk6qiAzX4JfJ3Ull7czfyaTNKS2jBC3TA7dkoE=;
        b=Xn3knpI6S0TI8SVmIeZrUwd+IEGZNMDmPgcij92G0qK4tt77hhMmanzKBOqdmIgvMQ
         kmuQkzZmdNo8jx4vQMELuo6KxIjln5xx4Kzi7wRL7lDVHGvKfP9yp0KsBsM56wue7U+I
         fQMQqvEyQhchMIwfqNcizm/Yg8Ak0D4ytlLuEgebQLk6JjEYr4+2TWd4BWevC0JBmmOl
         KQGVHIY9+YiZobLFuM7tN3lgotmwE3QWrjmJgHOK2cI7gZCjNd6y/WdqURlduVpku7xV
         ciQTqLJ6YXgqMndoJMh+PiAZ8BZMTbg87rC45a+wN5kd1NKpdF2LchzQUGZGBqyXo4s8
         00JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qzAcxQk6qiAzX4JfJ3Ull7czfyaTNKS2jBC3TA7dkoE=;
        b=kS7FjQ3CMxwm0sy8+Xbn2Lds7l0B/beJOtbAkguhh0ey5/aqFsCX2ppFjmMdbMPxWt
         XD/ACoTCoRFiV9iS3V9tzJMbEh6Ueey0mZZTKJI0LW8rKeGSE/iEEGaJSLqAj3557VbX
         IVhRorI/Ox9PNP7SW5pgWCSqg6JYBfGyBRrcnmeTKAavfgGjnYxxf/n0pVjZgChhB+yc
         85646vEHSM+v7jsWMP6Yao+D5xwAiyRLkZfpBqpjr82swSmozyQ+lh51J49XjwsrwYoZ
         DsgCh22f47w/nQ4uFovHzgR4TnzS67ZDNCDLtMSq0N4jemSYAGHZKT0RNDv/PMojeaK5
         j2RA==
X-Gm-Message-State: ACrzQf3W+34k9ikT3bbsBH7Z5bUuYuPX1shPM9Klw3NGoqzjCdSJCFVr
        0R4VyJ7Z4RtQ6Lf32gQxeRQH30HAUedLqB/oHF0X/g==
X-Google-Smtp-Source: AMsMyM5lCLe4qOgbPdIvr8xMZJqM34ul1uP6RDEMDwek8tLA0fKhPkv5Fu0o4vFuaEE7KTys/HuSmaRNHZwvkqkWOrg=
X-Received: by 2002:a17:90a:66c9:b0:20a:f78a:77e4 with SMTP id
 z9-20020a17090a66c900b0020af78a77e4mr16057828pjl.214.1665740040131; Fri, 14
 Oct 2022 02:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220819174659.2427983-1-vannapurve@google.com>
 <20220819174659.2427983-4-vannapurve@google.com> <Yz80XAg74KGdSqco@google.com>
In-Reply-To: <Yz80XAg74KGdSqco@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Fri, 14 Oct 2022 15:03:48 +0530
Message-ID: <CAGtprH_XSCXZDroGUnL3H1CwcsbH_A_NDn8B4P2xfpSYGqKmqw@mail.gmail.com>
Subject: Re: [RFC V3 PATCH 3/6] selftests: kvm: ucall: Allow querying ucall
 pool gpa
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        shuah@kernel.org, yang.zhong@intel.com, drjones@redhat.com,
        ricarkol@google.com, aaronlewis@google.com, wei.w.wang@intel.com,
        kirill.shutemov@linux.intel.com, corbet@lwn.net, hughd@google.com,
        jlayton@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, chao.p.peng@linux.intel.com,
        yu.c.zhang@linux.intel.com, jun.nakajima@intel.com,
        dave.hansen@intel.com, michael.roth@amd.com, qperret@google.com,
        steven.price@arm.com, ak@linux.intel.com, david@redhat.com,
        luto@kernel.org, vbabka@suse.cz, marcorr@google.com,
        erdemaktas@google.com, pgonda@google.com, nikunj@amd.com,
        diviness@google.com, maz@kernel.org, dmatlack@google.com,
        axelrasmussen@google.com, maciej.szmigiero@oracle.com,
        mizhang@google.com, bgardon@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 7, 2022 at 1:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 19, 2022, Vishal Annapurve wrote:
> > Add a helper to query guest physical address for ucall pool
> > so that guest can mark the page as accessed shared or private.
> >
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > ---
>
> This should be handled by the SEV series[*].  Can you provide feedback on that
> series if having a generic way to map the ucall address as shared won't work?
>
> [*] https://lore.kernel.org/all/20220829171021.701198-1-pgonda@google.com

Based on the SEV series you referred to, selftests are capable of
accessing ucall pool memory by having encryption bit cleared (as set
by guest pagetables) as allowed by generic API vm_vaddr_alloc_shared.
This change is needed in the context of fd based private memory where
guest (specifically non-confidential/sev guests) code in the selftests
will have to explicitly indicate that ucall pool address range will be
accessed by guest as shared.
