Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6264668DBD8
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjBGOlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjBGOlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:41:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB02340BF9;
        Tue,  7 Feb 2023 06:39:38 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675780756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mC/omiePBfZ5+VVhH6QfIH24BYMC7zeloSnAmwd1DQ8=;
        b=0ZEsle7ajmkg3PipAlgYILFpfbvnEBb0aBw9COqNT8vVQ3+5tTEDdNOtkANE9BfowobjY7
        bQ//7r6BLT045ITZwjKxapDNcU4HWNdQIg/pq5x7IFEBq4ZQClURbTYL2qIE8LRNniOL9/
        eSHe64rHVwrX/oLEDFWjVzbhtMj5mtEbgIhUtN4Gyi/osxHxwBBelBh2mGjgETbjBxfTY7
        0/ZDMqiYIMF/Oqe2mHZWwlT4wg6D3WDTf5nQHLyso7m4NUMqpASZOgp9Y366fGWtNGQenF
        4s3jscunNzHslK5ZHDkmyluTdga1Tu6Q2z4MVPsslp5l26v//TJuJP6qzEI42Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675780756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mC/omiePBfZ5+VVhH6QfIH24BYMC7zeloSnAmwd1DQ8=;
        b=MZeMoVOz3WvTBd75mMTgBcJyNKiQwq0MARmYAQdr9uehfsRa4EmVkJJFRBuVBBdbvJuReN
        EW/jKFiLk0PLJJAQ==
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 04/11] x86/smpboot: Reference count on
 smpboot_setup_warm_reset_vector()
In-Reply-To: <57195f701f6d1d70ec440c9a28cbee4cfb81dc41.camel@amazon.co.uk>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-5-usama.arif@bytedance.com> <871qn2xsmf.ffs@tglx>
 <57195f701f6d1d70ec440c9a28cbee4cfb81dc41.camel@amazon.co.uk>
Date:   Tue, 07 Feb 2023 15:39:15 +0100
Message-ID: <87sffhv8to.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David!

On Tue, Feb 07 2023 at 09:49, David Woodhouse wrote:

Can you please fix your mail client to _NOT_ send multipart/mixed mails?
Despite the CC list being insanely large, your replies are dropped by
vger and missing in the archives.

> On Tue, 2023-02-07 at 00:48 +0100, Thomas Gleixner wrote:
>> On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
>> > From: David Woodhouse <dwmw@amazon.co.uk>
>> >=20
>> > If we want to do parallel CPU bringup, we're going to need to set this=
 up
>> > and leave it until all CPUs are done. Might as well use the RTC spinlo=
ck
>> > to protect the refcount, as we need to take it anyway.
>>=20
>> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#chang=
elog
>>=20
>> Aside of the 'We' this does not explain anything at all.
>
> Er, doesn't it?
>
> We refcount the warm reset vector because when we do parallel bringup,
> we'll want to set it up once and then put it back to normal (for cold
> reset) once all the CPUs are up.
>
> I can rework the phrasing; I'm aware that the whole nonsense about
> pronouns and the imperative mood has grown legs in the last couple of
> years since I originally wrote it =E2=80=94 but is there anything actually
> missing?=20

We can settle the imperative mood debate over a beer at the next
conference, but stuff which goes through tip is required to follow those
rules. No exception for you :)

Vs. the content: This changelog lacks context. Changelogs have to be
self contained and self explanatory. Assuming that they are
understandable due to the context of the patch series is just wrong. I
fundamentally hate it when I have to dig out the context when I stare at
the changelog of a commit.

So something like this:

   The warm reset vector on X86 is setup through the RTC (CMOS) clock
   for each CPU bringup operation and cleared after the CPU came online.

   Parallel bringup of multiple CPUs requires that the warm reset vector
   is valid until all CPUs came online.

   To prepare for that add refcounting for the reset vector and protect
   it with the rtc_lock which has to be taken for the setup operation
   anyway.

gives the full context and is simply factual, no?

Thanks,

       tglx


