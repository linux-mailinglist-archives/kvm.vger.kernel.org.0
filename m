Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7622C68F43A
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 18:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjBHRTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 12:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjBHRTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 12:19:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF314FADA
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 09:19:21 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o13so19060879pjg.2
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 09:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=br/w7p2chmkhe5ZmyrYBozOFHfWmnJMS7RWm3vZz5eQ=;
        b=GLJtA5g5vkcY6/ehlyOvfhtnb+xmb8+BZTrE3OsNvGQqIZu5RWsglnDoNIw7YBQVTg
         nmFKwyGFKAfEc0Sa/EhSGeMv3EInvcawqKHheJToTXZE79Ow73gNT5CLivd0B5Iqki3n
         kKU4tt7zE7RMUSoBKf7CLir/vSxKHVcQPutVI1BL1c5PdKYZZuQTfi9CVvYvCOk5jYSB
         0+CVhlTrceeo/IyF6odP6s+9+MbQzwbj++kzxbYTTOnJP4ngoTOAAGOAHwYawwJbhR3g
         ZHJKuw+I5QHk2sfoVl9YoZN+I6rUtfd94MOI+GV9NzK/FiDXuDmLG280BFwNm4j/Szv/
         EfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=br/w7p2chmkhe5ZmyrYBozOFHfWmnJMS7RWm3vZz5eQ=;
        b=C+Jw3d5rXVxBE5FSTe1eKrWPRL3TonbAUoI96vfi767/wMipwnjogtoLRhM+SLADzd
         g6W+sE4S4NUOTdWiDUcMqDoTYlfLrDmU2kk8guV9JM++oIONfOftRMdqNdh7igERbjvc
         TK0dIp7mLxn0ac0AUS29va/y4YbICM7417/PFkHJocUZBn9Ofq+K7r7rzJJI+3Yf23JK
         OF22NoHOOwWfk0aLC6PVa/A20uxM6KvFYqJcSIBR10fEjJ6pUIBC1VaLGxQH46za5XBD
         lZbla3cYB2AaFr6wvKGiQW+tfPRkiyG21zRkYgHZedWjujl6iPXcPsFqsQplhdL2TsL/
         QR2w==
X-Gm-Message-State: AO0yUKV+aoLw5GrbqON4fpat3WUcUumd3WOfKKuBuX9eFQpqUeClPEwn
        ZK/lMRGcRa1UM8dBaMWqa0RsCQ==
X-Google-Smtp-Source: AK7set+49RAiaWekePFIa3sPrbo69C4iz2+NgBFB0KBoklfq3cx+x41A/6qjC+PKWRH8j+ntp5xdgA==
X-Received: by 2002:a17:903:1cc:b0:198:af4f:de10 with SMTP id e12-20020a17090301cc00b00198af4fde10mr287778plh.16.1675876760788;
        Wed, 08 Feb 2023 09:19:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902868600b00192fe452e17sm11317847plo.162.2023.02.08.09.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:19:20 -0800 (PST)
Date:   Wed, 8 Feb 2023 17:19:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Kevin Cheng <chengkev@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] KVM: selftests: Added eBPF program and selftest to
 collect vmx exit stat
Message-ID: <Y+PZlD+KXZIkeOLr@google.com>
References: <20230126004346.4101944-1-chengkev@google.com>
 <Y+Fv6idxCMkuMf1R@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Fv6idxCMkuMf1R@google.com>
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

On Mon, Feb 06, 2023, David Matlack wrote:
> On Thu, Jan 26, 2023 at 12:43:46AM +0000, Kevin Cheng wrote:
> > +	int n = atoi(argv[1]);
> > +
> > +	for (int i = 0; i < n; i++) {
> > +		if (fork() == 0) {
> 
> Put the implementation of the child process into a helper function to
> reduce indentation.

+1 for the future, but for this sample test I wouldn't bother having the test
spawn multiple VMs.  IIUC, each child loads its own BPF program, i.e. the user
can achieve the same effect by running multiple instances of the test.

> > +			struct kvm_vm *vm;
> > +			struct kvm_vcpu *vcpu;
> > +
> > +			vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> > +
> > +			// BPF userspace code
> > +			struct bpf_object *obj;
> > +			struct bpf_program *prog;
> > +			struct bpf_map *map_obj;
> > +			struct bpf_link *link = NULL;
> > +
> > +			obj = bpf_object__open_file("kvm_vmx_exit_ebpf_kern.o", NULL);

Does the BPF program _have_ to be in an intermediate object file?  E.g. can the
program be embedded in the selftest?

> > +			if (libbpf_get_error(obj)) {
> > +				fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > +				return 0;
> 
> I notice the children and parent always return 0. The test should exit
> with a non-0 return code if it fails.

Just do TEST_ASSERT(), I don't see any reason to gracefully exit on failure.

> > +			}
> > +
> > +			map_obj = bpf_object__find_map_by_name(obj, "vmx_exit_map");
> > +			if (!map_obj) {
> > +				fprintf(stderr, "ERROR: loading of vmx BPF map failed\n");
> > +				goto cleanup;
> > +			}
> > +
> > +			struct bpf_map *pid_map = bpf_object__find_map_by_name(obj, "pid_map");
> > +
> > +			if (!pid_map) {
> > +				fprintf(stderr, "ERROR: loading of pid BPF map failed\n");
> > +				goto cleanup;
> > +			}
> > +
> > +			/* load BPF program */

...

> > +			for (int j = 0; j < 10000; j++)
> > +				vcpu_run(vcpu);
> 
> It might be interesting to (1) add some timing around this loop and (2)
> run this loop without any bpf programs attached. i.e. Automatically do
> an A/B performance comparison with and without bpf programs.

Hmm, I agree that understanding the performance impact of BPF is interesting, but
I don't think this is the right place to implement one-off code.  I would rather
we add infrastructure to allow selftests to gather timing statistics for run loops
like this, e.g. to capture percentiles, outliers, etc., and possibly to try to
mitigate external influences, e.g. pin the task to prevent migration and/or filter
out samples that appeared to be "bad" due to the task getting interrupted.

In other words, I worry that any amount of scope creep beyond "here's a BPF demo"
will snowball quickly :-)

> > diff --git a/tools/testing/selftests/kvm/kvm_vmx_exit_ebpf_kern.c b/tools/testing/selftests/kvm/kvm_vmx_exit_ebpf_kern.c
> > new file mode 100644
> > index 000000000000..b9c076f93171
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/kvm_vmx_exit_ebpf_kern.c
> 
> I think we should carve out a new directory for bpf programs. If we mix
> this in with the selftest .c files, it will start to get confusing.
> 
> e.g. tools/testing/selftests/kvm/bpf/vmx_exit_count.c

+1, though it should probably be tools/testing/selftests/kvm/bpf/x86_64/vmx_exit_count.c
Though we should rename the arch directories before we gain more usage of the bad
names[*]

And I suspect we'll also want add lib helpers, e.g. tools/testing/selftests/kvm/lib/bpf.{c,h},
possibly with per-arch files too.  E.g. to wrap bpf_object__open_file() and
one or more bpf_object__find_map_by_name() calls.

[*] https://lore.kernel.org/all/Y5jadzKz6Qi9MiI9@google.com
