Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C57617617
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 06:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKCFWF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Nov 2022 01:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCFWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 01:22:03 -0400
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8687613E9A;
        Wed,  2 Nov 2022 22:22:02 -0700 (PDT)
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id DAB8414048F;
        Thu,  3 Nov 2022 05:22:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id B066B2000E;
        Thu,  3 Nov 2022 05:21:31 +0000 (UTC)
Message-ID: <d92ada3062bc1c3a7557bfa0499fc4a8cee3aa10.camel@perches.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix a typo about the usage of kvcalloc()
From:   Joe Perches <joe@perches.com>
To:     "liaochang (A)" <liaochang1@huawei.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 02 Nov 2022 22:21:55 -0700
In-Reply-To: <26cda02a-af8d-5976-9d3a-a595c0ed2fb6@huawei.com>
References: <20221103011749.139262-1-liaochang1@huawei.com>
         <Y2Mpgm+zEetfZlWM@debian.me>
         <26cda02a-af8d-5976-9d3a-a595c0ed2fb6@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: B066B2000E
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: gmdzq5sn7iw343nbpmuc7fabxehjokgd
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+w7uVnmjLZRKLHD7OJm2ieqtVexUKMVaw=
X-HE-Tag: 1667452891-482577
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-03 at 12:18 +0800, liaochang (A) wrote:
> 
> 在 2022/11/3 10:37, Bagas Sanjaya 写道:
> > This isn't typofix as suggested from the patch subject, right?
> 
> Well, since kvcalloc uses the product of 1st and 2nd argument to do allocation,
> hence current code supposes to work well, but the usage is obviously no sense,
> that is why i name it a 'typo' and make it correct ;)
> 

Seems there are several of these typo/defects.

$ git grep -P 'calloc\s*\(\s*sizeof'
arch/x86/kvm/cpuid.c:   array.entries = kvcalloc(sizeof(struct kvm_cpuid_entry2), cpuid->nent, GFP_KERNEL);
drivers/gpu/drm/nouveau/nouveau_svm.c:  buffer->fault = kvcalloc(sizeof(*buffer->fault), buffer->entries, GFP_KERNEL);
drivers/scsi/bfa/bfad_bsg.c:    buf_base = kcalloc(sizeof(struct bfad_buf_info) +
drivers/soc/fsl/dpio/dpio-service.c:    ed = kcalloc(sizeof(struct qbman_eq_desc), 32, GFP_KERNEL);
fs/btrfs/send.c:        sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
kernel/bpf/bpf_local_storage.c: smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
kernel/watch_queue.c:   pages = kcalloc(sizeof(struct page *), nr_pages, GFP_KERNEL);
tools/lib/bpf/libbpf.c: gen = calloc(sizeof(*gen), 1);
tools/objtool/check.c:  struct cfi_state *cfi = calloc(sizeof(struct cfi_state), 1);
tools/objtool/check.c:  file->pv_ops = calloc(sizeof(struct pv_state), nr);
tools/perf/builtin-record.c:            rec->switch_output.filenames = calloc(sizeof(char *),
tools/perf/util/bpf-loader.c:   priv = calloc(sizeof(*priv), 1);
tools/perf/util/hist.c:         he->res_samples = calloc(sizeof(struct res_sample),
tools/perf/util/metricgroup.c:  metric_events = calloc(sizeof(void *), ids_size + 1);
tools/perf/util/stat-shadow.c:                  metric_events = calloc(sizeof(struct evsel *),
tools/perf/util/synthetic-events.c:     synthesize_threads = calloc(sizeof(pthread_t), thread_nr);
tools/perf/util/synthetic-events.c:     args = calloc(sizeof(*args), thread_nr);
tools/testing/selftests/arm64/fp/fp-stress.c:   children = calloc(sizeof(*children), tests);
tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c: link = calloc(sizeof(struct bpf_link *), prog_cnt);
tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c: prog = calloc(sizeof(struct bpf_program *), prog_cnt);
tools/testing/selftests/bpf/test_progs.c:       dispatcher_threads = calloc(sizeof(pthread_t), env.workers);
tools/testing/selftests/bpf/test_progs.c:       data = calloc(sizeof(struct dispatch_data), env.workers);
tools/testing/selftests/bpf/test_progs.c:       env.worker_current_test = calloc(sizeof(int), env.workers);
tools/testing/selftests/bpf/test_progs.c:               env.worker_pids = calloc(sizeof(__pid_t), env.workers);
tools/testing/selftests/bpf/test_progs.c:               env.worker_socks = calloc(sizeof(int), env.workers);
tools/testing/selftests/memfd/fuse_test.c:      zero = calloc(sizeof(*zero), mfd_def_size);

