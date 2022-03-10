Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6200C4D510D
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 18:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245262AbiCJR7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 12:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245258AbiCJR7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 12:59:33 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D312E158DAF
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:58:31 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso8921338pjb.1
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R06mJA/QDlJgqpuXPq9itgdAo42/FLsZYE2RPvXJtdQ=;
        b=SHHWECtEk9DczbmvbT3CmkjgP8Nud3QNNzkuHeHs5dvvzr7YSz9vlyjjUGofkYuN74
         8bqFJB8n7jiGAtz/lruBQg6wjM4puDCMk3qs5+g3a7ANq8dcWdjSIYC1nsBTp64XV083
         XObhkitInFG0DdRBJ/krih+Tn2WMx8wJwxTYvuC38maZIbTyW3VxLkMEyEjcaLaqS1JB
         SueZugQZStpwxJ4BA5/ziQc+wwtqCi/fwtf+pfrwmP0ZJcJFRreGYD5ttWcegMldzBBm
         dgG7eU9IVZ+AOgIp4h3sxZfvdhHVtleLOjf36HEsA2JmXSrTUEpS2QKbMC81+fLtijQE
         3Ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R06mJA/QDlJgqpuXPq9itgdAo42/FLsZYE2RPvXJtdQ=;
        b=HAmDB7bkxmSk7Pgci/w4ACnepsA8WBw3mBc3arDAc3q2dqVB07gKi2e4eUwF/t4X8F
         xF29wbIgT3dAdb2q4+UAOrsbsHiC9F4+ODAJENezdZWCuvWqKDXSW+ta40kPYaUQk/Di
         kcwytGXc9Muip0hbVZhISlnoXqAEDJmzBeyYTSUwhvM8A1OMotYWo/Njpkwgu/8NO3K/
         +t0YugdhOVU+1pnGgvTuUwqx2E+6rET9bdt+vMLW39nRYDGtl2Y4aw5lv8PFF+G+kgA5
         9zhB7CxNXOax8cIzN23N1sVlhqP2wWBKh3E3O9Npqx90mAwejYdMrRzRcVpM45dgXfVf
         YuGA==
X-Gm-Message-State: AOAM533kshDqM3HZV7LtdPueRidCeNDuhhoBG3X2HgftXpLOGsBJENGC
        DQpaNNkvpvuec3FOA1C4NKsFUA==
X-Google-Smtp-Source: ABdhPJyfnbvCpB67Z+YNGTCGld4EtfzKxLFs4Q6KYD6j93YpCVj0QQd3X1iAxcRTJ2aA/PlfqeIJBA==
X-Received: by 2002:a17:90a:73ce:b0:1bf:702c:f384 with SMTP id n14-20020a17090a73ce00b001bf702cf384mr17712918pjk.177.1646935111154;
        Thu, 10 Mar 2022 09:58:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090aa00c00b001bc6f1baaaesm10460015pjp.39.2022.03.10.09.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 09:58:30 -0800 (PST)
Date:   Thu, 10 Mar 2022 17:58:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH 00/13] KVM: x86: Add a cap to disable NX hugepages on a VM
Message-ID: <Yio8QtuMd6COcnEw@google.com>
References: <20220310164532.1821490-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022, Ben Gardon wrote:
>   selftests: KVM: Wrap memslot IDs in a struct for readability
>   selftests: KVM: Add memslot parameter to VM vaddr allocation
>   selftests: KVM: Add memslot parameter to elf_load

I really, really, don't want to go down this path of proliferating memslot crud
throughout the virtual memory allocators.  I would much rather we solve this by
teaching the VM creation helpers to (optionally) use hugepages.  The amount of
churn required just so that one test can back code with hugepages is absurd, and
there's bound to be tests in the future that want to force hugepages as well.
