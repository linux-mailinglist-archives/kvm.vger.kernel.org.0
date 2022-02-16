Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE844B8F4A
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 18:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiBPRih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 12:38:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbiBPRig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 12:38:36 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA29F6DA
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:38:23 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id d23so5157263lfv.13
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CLGpzGzLWEEIPQa2RoBV1b48UAm//y/cN1v178XuBnY=;
        b=YIKcsqMF3eKCVXPEAvcBo0+LNPTAgkAASeO6TNkeW/s+2ROdkA/A6HTyBI6TEk091E
         B+exaNzlJPBcARjAcThzqD4S5H2FK9wus6v6wgaLIcKaG9xbSqNh5dr+JoMY/IeVZ6HC
         26KBmcLh4TfDJEHR0OxdK2PearXUSrey6TC85sSCQM4kpIoBfcFgh5f7BJlHw0vEWk+s
         cjX7wCAZPK2PEtYu3K4aHj66MVQsSX+im8nuXKCvlrMiart2SBR8er73ICykTrReN3/r
         QEnKJtgYFY/mZbTIQCb6SI/3L5fSkEQPTmVqa4mH1IjhzaCsuObSUs93pQeBcOmqG2WH
         ZY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CLGpzGzLWEEIPQa2RoBV1b48UAm//y/cN1v178XuBnY=;
        b=C73vkkQ6XIJD6QB45g/1np4H3KMhlvv/0cqU0hgSUKri5TCV8XRhvzq19sTFQcZ2VE
         rWSUXx9gev1toqqpfC77G2B+mqGwfDqqr9Hg3kJDRhDDjvacn+ROtFg0u8WgSPxvlmVg
         TzwVh3QrajAc23QjCqiKISyZTKNeLEixx3ZQOFGbcXafKV6qcKos9IHZl8jdhuOTKwS0
         UC6Pkx4jwT+dfcY/3a0LXzrmVQnhVuO9FRch0GUTVnchNU/BZKgWUhDN1HfkavCdnI7w
         hwOoigBhQquOVYkAlv/ztrSNR9LcY/19NqjnvPaYfJ1F0bNdlSusstsFC+LV/vVs0Hom
         tdyQ==
X-Gm-Message-State: AOAM530+GrH/ukfznvIXs525FYmvOEjtUV7dhIN/2bPhR3Cm1TgycMps
        nnp4NGbRUsxVzKApM/4RCrGd0xDSmzYo6jqadtqkww==
X-Google-Smtp-Source: ABdhPJwNKe5xPv9L7nEZ8pEZrE0nqEvTSQOI9uOjdLNagMGSvQN6g9gDhIb98Z/Dr0yqyNhx35ovoN+c/L+RavqRqt4=
X-Received: by 2002:a05:6512:965:b0:443:7340:9893 with SMTP id
 v5-20020a056512096500b0044373409893mr2792075lft.119.1645033101394; Wed, 16
 Feb 2022 09:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20211222225350.1912249-1-vipinsh@google.com> <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org> <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
 <YehY0z2vHYVZk52J@slm.duckdns.org> <20220120150502.GC27269@blackbody.suse.cz>
In-Reply-To: <20220120150502.GC27269@blackbody.suse.cz>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 16 Feb 2022 09:37:45 -0800
Message-ID: <CAHVum0fOP-2XcUcG3PqW08DY7CmpDroG6Fcv9KoD1FqLmGpB8w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, seanjc@google.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com,
        jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo, Michal

Paolo:
Will you accept a patch which uses real_parent in
kvm_vm_worker_thread() as suggested by Sean, while I figure out the
recommendation from Michal about making kthread_stop() wait on
kernel_wait()?
        cgroup_attach_task_all(current->real_parent, current)

Michal:

On Thu, Jan 20, 2022 at 7:05 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> On Wed, Jan 19, 2022 at 08:30:43AM -1000, Tejun Heo <tj@kernel.org> wrote=
:
> > It'd be nicer if we can make kthread_stop() waiting more regular but I
> > couldn't find a good existing place and routing the usual parent
> > signaling might be too complicated. Anyone has better ideas?
>
> The regular way is pictured in Paolo's diagram already, the
> exit_notify/do_signal_parent -> wait4 path.
>
> Actually, I can see that there exists already kernel_wait() and is used
> by a UMH wrapper kthread. kthreadd issues ignore_signals() so (besides
> no well defined point of signalling a kthread) the signal notification
> is moot and only waking up the waiter is relevant. So kthread_stop()
> could wait via kernel_wait() based on pid (extracted from task_struct).
>
> Have I missed an obstacle?
>

I must admit I do not have a good understanding of kernel_wait() and
kthread_stop() APIs. I tried making some changes in the kthread_stop()
but I was not able to successfully use the API. I tested it by a
writing a test module, where during the init I start a kthread which
prints some message every few seconds and during the module exit I
call kernel_stop(). This module worked as intended without the
kernel_wait() changes in the kthread_stop() API.

My changes were basically replacing wait_for_completion() with
kernel_wait() call.

@@ -645,8 +645,9 @@ int kthread_stop(struct task_struct *k)
        set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
        kthread_unpark(k);
        wake_up_process(k);
-       wait_for_completion(&kthread->exited);
-       ret =3D k->exit_code;
+       kernel_wait(k->pid, &ret);
+//     kernel_wait(task_pid_vnr(k), &ret);
+//     wait_for_completion(&kthread->exited);
+//     ret =3D k->exit_code;
        put_task_struct(k);

I used few other combination where I put kernel_wait() call after
put_task_struct(k) call.

Every time during the module exit, kernel was crashing like:

[  285.014612] RIP: 0010:0xffffffffc04ed074
[  285.018537] RSP: 0018:ffff9ccdc8365ee8 EFLAGS: 00010246
[  285.023761] RAX: 0000000000000000 RBX: 0000000000000012 RCX: 00000000000=
00001
[  285.030896] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff9cce3f7=
d9cc0
[  285.038028] RBP: ffff9ccdc8365ef8 R08: 0000000000000000 R09: 00000000000=
15504
[  285.045160] R10: 000000000000004b R11: ffffffff8dd92880 R12: 00000000000=
00012
[  285.052293] R13: ffff9ccdc813db90 R14: ffff9ccdc7e66240 R15: ffffffffc04=
ed000
[  285.059425] FS:  0000000000000000(0000) GS:ffff9cce3f7c0000(0000)
knlGS:0000000000000000
[  285.067510] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.073258] CR2: ffffffffc04ed074 CR3: 000000c07f20e002 CR4: 00000000003=
62ef0
[  285.080390] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  285.087522] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  285.094656] Call Trace:
[  285.097112]  kthread+0x148/0x1b0
[  285.100343]  ? kthread_blkcg+0x30/0x30
[  285.104096]  ret_from_fork+0x3a/0x60
[  285.107671] Code:  Bad RIP value.
[  285.107671] IP: 0xffffffffc04ecff4:

Crash is not observed if I keep wait_for_completion(&kthread->exited)
along with kernel_wait(), but I guess the kernel_wait() should be
sufficient by itself if I figure out proper way to use it.

Do you have any suggestions what might be the right way to use this API?

Thanks
Vipin
