Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B2D6412E6
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 02:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiLCBDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 20:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLCBDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 20:03:44 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9CDC8D1C
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 17:03:43 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id jn7so6114047plb.13
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 17:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7F06+jiJvvR5kLNucI/jSZnJxR6nKoA0ANvxE9pg4M=;
        b=DIOo6kDCGjvlTfwtyULHyUJk9L+Z4A4YNcAQxf4FklyMRlpQn/1LK4q93Nx76CB9f4
         rkLEYHqLxRTHNMCmsRm9VzFPJ+GqgiyhMuHqMrD225loO9/cKnjBrLq0L3oHqwNmRdE7
         RhJn02zgMsQVHeTXjREi33/ZgupObgR3HFDecQule7KkNsgP6fmlQ85wQ+0dILbmWEbe
         C42RUfyRrLKUqRkJWPyZDlYPUBQxFAIScUqcFc+0kMnlTBzH6URCBYsXUiLguruwjTHn
         /W5RBsaOF9AeS/gYxGIOeTf1yPq+XCxGmh32aBNxHTtOhIWtfkXEX3B1EemJDso023m3
         K4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7F06+jiJvvR5kLNucI/jSZnJxR6nKoA0ANvxE9pg4M=;
        b=c0zU3M+wZsMB3PQ8zobQdBp88WhdxYFj36N7hwS1oM2SIWavR7WZzGKAqyH54mPFVJ
         qGyurxm9cn6BB8FN2HdNzNNcEtrUd98wWGSLjvn3qYx3ySijqd8E3lcZ8GxeKSdP2qQP
         6NgMYl6yK8sIawrofftL/CwOUc/ctqEX52Z7qWr7eFMF71o5FaVKkowEC0Q7/Vp4yiHf
         dm71M+lbYrhDLsvfSjOzbVg2zpztObTMilPbazm/FcRf7Rh7q4S9qVdwM5UQxGthCi8T
         4fHyn/Zq+RebxKFgNQkcgaI6gSh/d2+qGpNqBgZjUkAwoT9ITBbSmL3f5sNCIcdS2Fa4
         U8zQ==
X-Gm-Message-State: ANoB5ploQN/Um5iL1OFL++YX8WMackxrhnLETBaGeje9Nshg1m4bYeid
        k/uRlLmU0QfHxaFovXqAwO8Jbg==
X-Google-Smtp-Source: AA0mqf4YyWU2oW8MStbh25D1tKWGrrbii+YzsH1DwP1rtwHYgviG5o1HZ1drOKdsi/mUsyxPBr/k4A==
X-Received: by 2002:a17:902:d2c8:b0:189:3e8f:fa37 with SMTP id n8-20020a170902d2c800b001893e8ffa37mr50787524plc.76.1670029422437;
        Fri, 02 Dec 2022 17:03:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id nt15-20020a17090b248f00b00217090ece49sm5319758pjb.31.2022.12.02.17.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 17:03:42 -0800 (PST)
Date:   Sat, 3 Dec 2022 01:03:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     James Houghton <jthoughton@google.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y4qgampvx4lrHDXt@google.com>
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
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

On Thu, Dec 01, 2022, James Houghton wrote:
> #1, however, is quite doable. The main codepath for post-copy, the
> path that is taken when a vCPU attempts to access unmapped memory, is
> (for x86, but similar for other architectures): handle_ept_violation
> -> hva_to_pfn -> GUP -> handle_userfault. I'll call this the "EPT
> violation path" or "mem fault path." Other post-copy paths include at
> least: (i) KVM attempts to access guest memory via.
> copy_{to,from}_user -> #pf -> handle_mm_fault -> handle_userfault, and
> (ii) other callers of gfn_to_pfn* or hva_to_pfn* outside of the EPT
> violation path (e.g., instruction emulation).
> 
> We want the EPT violation path to be fast, as it is taken the vast
> majority of the time.

...

> == Getting the faulting GPA to userspace ==
> KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
> and it provides the main functionality we need. We can extend it
> easily to support our use case here, and I think we have at least two
> options:
> - Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
> KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
> otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
> -EFAULT).
> - We're already introducing a new CAP, so just tie the above behavior
> to whether or not one of the CAPs (below) is being used.

We might even be able to get away with a third option: unconditionally return
KVM_EXIT_MEMORY_FAULT instead of -EFAULT when the error occurs when accessing
guest memory.

> == Problems ==
> The major problem here is that this only solves the scalability
> problem for the KVM demand paging case. Other userfaultfd users, if
> they have scalability problems, will need to find another approach.

It may not fully solve KVM's problem either.  E.g. if the VM is running nested
VMs, many (most?) of the user faults could be triggered by FNAME(walk_addr_generic)
via __get_user() when walking L1's EPT tables.

Disclaimer: I know _very_ little about UFFD.

Rather than add yet another flag to gup(), what about flag to say the task doesn't
want to wait for UFFD faults?  If desired/necessary, KVM could even toggle the flag
in KVM_RUN so that faults that occur outside of KVM ultimately don't send an actual
SIGBUGS.

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 07c81ab3fd4d..7f66b56dd6e7 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -394,7 +394,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
         * shmem_vm_ops->fault method is invoked even during
         * coredumping without mmap_lock and it ends up here.
         */
-       if (current->flags & (PF_EXITING|PF_DUMPCORE))
+       if (current->flags & (PF_EXITING|PF_DUMPCORE|PF_NO_UFFD_WAIT))
                goto out;
 
        /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ffb6eb55cd13..4c6c53ac6531 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1729,7 +1729,7 @@ extern struct pid *cad_pid;
 #define PF_MEMALLOC            0x00000800      /* Allocating memory */
 #define PF_NPROC_EXCEEDED      0x00001000      /* set_user() noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH           0x00002000      /* If unset the fpu must be initialized before use */
-#define PF__HOLE__00004000     0x00004000
+#define PF_NO_UFFD_WAIT                0x00004000
 #define PF_NOFREEZE            0x00008000      /* This thread should not be frozen */
 #define PF__HOLE__00010000     0x00010000
 #define PF_KSWAPD              0x00020000      /* I am kswapd */

