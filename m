Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80D35FA2C9
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 19:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJJRiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 13:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJJRix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 13:38:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3B275498
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 10:38:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c20so1414144plc.5
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 10:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOU2BcWLYOA9KzmjvFlxSiSMKvzt+IxyK7JOTpl0+rM=;
        b=akN1kyklQfbsl8fgDRxJrUQGn6cvGqZiAN5wmYwMDgKNEXKJe7o4XeGaHpcA6Yb/1d
         uUlZHvp7TiN5eNQAdunzh7Cboi8v/9Hdf/Xg3EgaLDgvg4AbsutNsRk6QOV/N8XuVSoH
         J+dLPY+be49jTd4Pp4QD6jcKlQykq60MWW72SsZCZjO3iFtYA/MIyOl0g3odW3DwC7/k
         M4cXN0kIF5CX533bR0GMrFOjxNna1SawWEPtvZQ1RxADUcS6XzJMvbSw+YCE9jbHTXBW
         bv0M4lfQZRZIZIveWVzVDrTt8AXVv6rTs35WmLNEehnBD9O3onR9TVgukKyCvpOj1qbx
         Ml3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOU2BcWLYOA9KzmjvFlxSiSMKvzt+IxyK7JOTpl0+rM=;
        b=GBIbqv3353G7OBIclrzIYyA/yX6dhryyWONLVTKSQXVpGBTgCuGf4y9OmE6C1sctQC
         VDwgDC6ZsO6nqs2ppaL8b4FkO/kST/59JRFW5iJUaiNYkhKFK+IZx4eDVfmM4/1TCdb3
         8mWVyKDZSvYdpJ5YykAhHP55tiVMR33Gts8epjerErpS6vV9DpReOVlEhhlPZe7CtE3G
         t8Drk6zWOIcOjOrlICf8ckzopGzDMiPn1L3C5nR2atcf+44YgRp23MPU4FQ91pKpq2md
         ZDnfn1Pkr3qBjnRRVlbOuXilrK6qozG/7qzcP8W93f0Ol0iIRCFn5ws4Qt1nU5Xna3+X
         d0rw==
X-Gm-Message-State: ACrzQf3Nh6Q9+cVOypa+Eu3MQYCNtOqYfuggaNphJgrK1VisL9NOPTsZ
        uzMTQB/cVkLpzls/MeVJRhcV6+ym4CCTEA==
X-Google-Smtp-Source: AMsMyM5AQHWfPBcwnLLDhL15DT9q4FJszTgl7PaTn694IyJSB5wP2kld5NywkcD7wVVkCpIGzCKikg==
X-Received: by 2002:a17:902:bd85:b0:178:8e76:c77e with SMTP id q5-20020a170902bd8500b001788e76c77emr20960984pls.38.1665423531955;
        Mon, 10 Oct 2022 10:38:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h23-20020aa796d7000000b0056276519e8fsm7150183pfq.73.2022.10.10.10.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 10:38:51 -0700 (PDT)
Date:   Mon, 10 Oct 2022 17:38:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: keep srcu writer side operation mutually
 exclusive
Message-ID: <Y0RYp7CZO5u1Eg/s@google.com>
References: <CAPm50a+aygp3T1mNjzGXtL2nyNm-mHFZ3YO8F7eO0gCxZDuQsA@mail.gmail.com>
 <Y0BeEVxkDkctmTIX@google.com>
 <CAPm50aLzOLyURhvhYkCyp1hpRagAczFXg9jYbFg_86Qaf5usbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50aLzOLyURhvhYkCyp1hpRagAczFXg9jYbFg_86Qaf5usbg@mail.gmail.com>
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

On Sun, Oct 09, 2022, Hao Peng wrote:
> On Sat, Oct 8, 2022 at 1:12 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sat, Oct 08, 2022, Hao Peng wrote:
> > > From: Peng Hao <flyingpeng@tencent.com>
> > >
> > > Synchronization operations on the writer side of SRCU should be
> > > invoked within the mutex.
> >
> > Why?  Synchronizing SRCU is necessary only to ensure that all previous readers go
> > away before the old filter is freed.  There's no need to serialize synchronization
> > between writers.  The mutex ensures each writer operates on the "new" filter that's
> > set by the previous writer, i.e. there's no danger of a double-free.  And the next
> > writer will wait for readers to _its_ "new" filter.
> >
> Array srcu_lock_count/srcu_unlock_count[] in srcu_data, which is used
> alternately to determine
> which readers need to wait to get out of the critical area. If  two
> synchronize_srcu are initiated concurrently,
> there may be a problem with the judgment of gp. But if it is confirmed
> that there will be no writer concurrency,
> it is not necessary to ensure that synchronize_srcu is executed within
> the scope of the mutex lock.

I don't see anything in the RCU documentation or code that suggests that callers
need to serialize synchronization calls.  E.g. the "tree" SRCU implementation uses
a dedicated mutex to serialize grace period work 

	struct mutex srcu_gp_mutex;		/* Serialize GP work. */

static void srcu_advance_state(struct srcu_struct *ssp)
{
	int idx;

	mutex_lock(&ssp->srcu_gp_mutex);

	<magic>
}


and its state machine explicitly accounts for "Someone else" starting a grace
period

		if (idx != SRCU_STATE_IDLE) {
			mutex_unlock(&ssp->srcu_gp_mutex);
			return; /* Someone else started the grace period. */
		}

and srcu_gp_end() also guards against creating more than 2 grace periods.

	/* Prevent more than one additional grace period. */
	mutex_lock(&ssp->srcu_cb_mutex);

And if this is a subtle requirement, there is a lot of broken kernel code, e.g.
mmu_notifier, other KVM code, srcu_notifier_chain_unregister(), etc...
