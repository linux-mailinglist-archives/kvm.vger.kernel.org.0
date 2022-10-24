Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6A6098E4
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 05:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJXDa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 23:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJXDa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 23:30:28 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F967AC2E;
        Sun, 23 Oct 2022 20:27:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h9so3031075wrt.0;
        Sun, 23 Oct 2022 20:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O2esLByeb54271i903kEfYtOSyfIyaU9h31aBI1kHSw=;
        b=lCa50AmhMTksHcOD90KBgXpupfnNLPbfG/5ZPGhmRq7XEue+QE1lgitzcgeCQrvplY
         hzAWzEJ8uQ++kiBiZpV48ZTS2Irsi2kp/kyiJrwGlOz9NimpeR96yru/S1Eje+9x8D6h
         iIVDFMEpvb9pVYYuYWakU4qie+9RfEb0dSVmrXPB+FW7Gtw8Rneh+IDU215btfBzf5iO
         VplAG0In1C79anDxBVoDU/VrbqQSAhl1TOMioUowdZNnEdsgkZNu1xhgjn5bOI8KaWxQ
         0mvJoCMW0htOmZXWBMd+d9GhKqbMfr/TT2gFmFkdbq55MSW2FtcEGS/5GWOxB/j/EVDw
         DqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O2esLByeb54271i903kEfYtOSyfIyaU9h31aBI1kHSw=;
        b=e5nExVe5YE2e3mLeswR3enz9s+SiGktzxAFJdDPnFzgukPZqtLMj/DVOaWDgqJNXlx
         THbl+JEE+GxWEfLMfCHR4RFw+SqW7bo8srN8av6XD3m25LIA+BXbo9adRWP8nhoXQmp6
         XpI8K3qqoXI5rhTRcVAv/yfvzvxeZ7jLnRSeBDBGMzSCfFWeBVP9ezjF9Avbtm/dIoat
         9f1vpT8s2/v+EypwOCDNtTw6orwE00UjpBiaZ7qAlSnGObRyzXITd8uUT8uT6i88H5UV
         0NpHAcTztK1Q4/vwaq633CrgkK/J7zaS3zmipBfVQ4Ji3iGVdK0bbf7rpMfxStk6Yeaj
         dBYQ==
X-Gm-Message-State: ACrzQf31Zog8+oYMM355msJoCHe25z6BbObe+VyYHlXz+RixTkXZO/+4
        M0wlbD21/QhO71dRf6iOugM99qE6gggzEpz/sREO2NahbJBfWg==
X-Google-Smtp-Source: AMsMyM4DhnQrMnsG4wcbCpqMZPxR8IShg+7kF/L6jDrU6EOYLyRvQe6ig0PatWYhRNhIhb1qc4kvGu7gcZJBrAsk0aI=
X-Received: by 2002:adf:e502:0:b0:234:bb21:e9cc with SMTP id
 j2-20020adfe502000000b00234bb21e9ccmr15184069wrm.389.1666582070646; Sun, 23
 Oct 2022 20:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAPm50a+aygp3T1mNjzGXtL2nyNm-mHFZ3YO8F7eO0gCxZDuQsA@mail.gmail.com>
 <Y0BeEVxkDkctmTIX@google.com> <CAPm50aLzOLyURhvhYkCyp1hpRagAczFXg9jYbFg_86Qaf5usbg@mail.gmail.com>
 <Y0RYp7CZO5u1Eg/s@google.com>
In-Reply-To: <Y0RYp7CZO5u1Eg/s@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Mon, 24 Oct 2022 11:27:38 +0800
Message-ID: <CAPm50aJUjCumrMmEGCw2eNc6nPi5y=ZzTMi8MC2aJwkatQGnww@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: keep srcu writer side operation mutually exclusive
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 1:38 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Oct 09, 2022, Hao Peng wrote:
> > On Sat, Oct 8, 2022 at 1:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Sat, Oct 08, 2022, Hao Peng wrote:
> > > > From: Peng Hao <flyingpeng@tencent.com>
> > > >
> > > > Synchronization operations on the writer side of SRCU should be
> > > > invoked within the mutex.
> > >
> > > Why?  Synchronizing SRCU is necessary only to ensure that all previous readers go
> > > away before the old filter is freed.  There's no need to serialize synchronization
> > > between writers.  The mutex ensures each writer operates on the "new" filter that's
> > > set by the previous writer, i.e. there's no danger of a double-free.  And the next
> > > writer will wait for readers to _its_ "new" filter.
> > >
> > Array srcu_lock_count/srcu_unlock_count[] in srcu_data, which is used
> > alternately to determine
> > which readers need to wait to get out of the critical area. If  two
> > synchronize_srcu are initiated concurrently,
> > there may be a problem with the judgment of gp. But if it is confirmed
> > that there will be no writer concurrency,
> > it is not necessary to ensure that synchronize_srcu is executed within
> > the scope of the mutex lock.
>
> I don't see anything in the RCU documentation or code that suggests that callers
> need to serialize synchronization calls.  E.g. the "tree" SRCU implementation uses
> a dedicated mutex to serialize grace period work
>
>         struct mutex srcu_gp_mutex;             /* Serialize GP work. */
>
> static void srcu_advance_state(struct srcu_struct *ssp)
> {
>         int idx;
>
>         mutex_lock(&ssp->srcu_gp_mutex);
>
>         <magic>
> }
>
>
> and its state machine explicitly accounts for "Someone else" starting a grace
> period
>
>                 if (idx != SRCU_STATE_IDLE) {
>                         mutex_unlock(&ssp->srcu_gp_mutex);
>                         return; /* Someone else started the grace period. */
>                 }
>
> and srcu_gp_end() also guards against creating more than 2 grace periods.
>
>         /* Prevent more than one additional grace period. */
>         mutex_lock(&ssp->srcu_cb_mutex);
>
> And if this is a subtle requirement, there is a lot of broken kernel code, e.g.
> mmu_notifier, other KVM code, srcu_notifier_chain_unregister(), etc...

srcu_gp_mutex is meaningless because the workqueue already guarantees
that the same work_struct will not be reentrant.
If synchronize_srcu is not mutually exclusive on the update side, it may cause
a GP to fail for a long time. I will continue to analyze when I have time.
