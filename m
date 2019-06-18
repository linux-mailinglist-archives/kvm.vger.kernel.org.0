Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60A4A9D3
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 20:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfFRS1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 14:27:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59566 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbfFRS1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 14:27:54 -0400
Received: from zn.tnic (p200300EC2F07D6002CC425FD7B5CF219.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:d600:2cc4:25fd:7b5c:f219])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 910FB1EC04CD;
        Tue, 18 Jun 2019 20:27:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1560882472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9VALxApjIsDH+dKu03BXeEyWL72iUXWtT0Bi4ZTps5c=;
        b=WXV6L4Y6ZRDtcYJ/NyKyEGhql146oFF1WXFhe4kHxgj8dXuaGzIwJnZ4qk09O5Ch+vYrL5
        5ICGeN8OhNSSejxt8PHqHAwSoheUrIQAtoqxDJBBc48yir97F2a3/erZ8FattEIq/RMXM0
        rWcUIwXzDLw8oYzekaYZFpTCNAADCsw=
Date:   Tue, 18 Jun 2019 20:27:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, KVM list <kvm@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
Message-ID: <20190618182733.GD26346@zn.tnic>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic>
 <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic>
 <20190612205430.GA26320@linux.intel.com>
 <20190613071805.GA11598@zn.tnic>
 <df80299b-8e1f-f48b-a26b-c163b4018d01@oracle.com>
 <20190618175153.GC26346@zn.tnic>
 <CACT4Y+bnKwniAikESjDckaTW=vE1hu8yc4DuoSFwP3qTS4NpmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+bnKwniAikESjDckaTW=vE1hu8yc4DuoSFwP3qTS4NpmA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 08:01:06PM +0200, Dmitry Vyukov wrote:
> I am not a KVM folk either, but FWIW syzkaller is capable of creating
> a double-nested VM.

Aaaha, there it is. :)

> The code is somewhat VMX-specific, but it should
> be capable at least executing some SVM instructions inside of guest.
> This code setups VM to run a given instruction sequences (should be generic):
> https://github.com/google/syzkaller/blob/34bf9440bd06034f86b5d9ac8afbf078129cbdae/executor/common_kvm_amd64.h
> The instruction generator is based on Intel XED so it may be somewhat
> Intel-biased, but at least I see some mentions of SVM there:
> https://raw.githubusercontent.com/google/syzkaller/34bf9440bd06034f86b5d9ac8afbf078129cbdae/pkg/ifuzz/gen/all-enc-instructions.txt

Right, and that right there looks wrong:

ICLASS    : VMLOAD
CPL       : 3
CATEGORY  : SYSTEM
EXTENSION : SVM
ATTRIBUTES: PROTECTED_MODE
PATTERN   : 0x0F 0x01 MOD[0b11] MOD=3 REG[0b011] RM[0b010]
OPERANDS  : REG0=OrAX():r:IMPL

That is, *if* "CPL: 3" above means in XED context that VMLOAD is
supposed to be run in CPL3, then this is wrong because VMLOAD #GPs if
CPL was not 0. Ditto for VMRUN and a couple of others.

Perhaps that support was added at some point but not really run on AMD
hw yet...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
