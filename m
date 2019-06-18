Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517F44AAEF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 21:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbfFRTRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 15:17:34 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:55436 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfFRTRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 15:17:34 -0400
Received: by mail-wm1-f47.google.com with SMTP id a15so4493945wmj.5
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 12:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABxDSF2a8xIK7V7SRHfrtq5pztaxwk/yhzJhxbHaPlY=;
        b=Jiy+hoiUT+kCdvvCTx/3ZsO5idFhBglziwam/ZwJM3Y7BdyTvVdhHeoyv78U+gMrjN
         a5XHYDpCAPjDFC/PhB65iRZTGNFbX1THYA3WDSvXUCNUhwD0kihVygPL+94jDNyxRfgy
         x2f+k5IUc998m2UQh7Sjwxr57iRBH50TBJwgk4yxOq5V+rM3aV845vI6/AgSBlRIxjpY
         FQ+HbqpxcVoRVVcNH/71xdNE+6jD2q93B7RHWqZR+qepMMiA8VgM+FvZ4qeUNTsuvrCI
         ZkczzmqlfTWML6XebVKxNnjn+x0Yp+JqR2ffsX5MUda+IsJ/U7yjYLO32GMdwNj4gzNq
         IZcg==
X-Gm-Message-State: APjAAAU+2v7cgbm3d5kHsRge6QidGbndTUUzVv1GvgxrtmtBNuZMXkXx
        3ISgDJA6nheo8rYnQmHiDtouKi80KYA=
X-Google-Smtp-Source: APXvYqzjVPopWxzpKDoaug/PuCzupULJmVtVUjNkrZKcJSXPdevsx38+E7CyUJDIRjDWOjjx4638ig==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr4725013wmc.16.1560885452787;
        Tue, 18 Jun 2019 12:17:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id y184sm3261952wmg.14.2019.06.18.12.17.26
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 12:17:32 -0700 (PDT)
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
To:     Borislav Petkov <bp@alien8.de>, Dmitry Vyukov <dvyukov@google.com>
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, KVM list <kvm@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic>
 <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic> <20190612205430.GA26320@linux.intel.com>
 <20190613071805.GA11598@zn.tnic>
 <df80299b-8e1f-f48b-a26b-c163b4018d01@oracle.com>
 <20190618175153.GC26346@zn.tnic>
 <CACT4Y+bnKwniAikESjDckaTW=vE1hu8yc4DuoSFwP3qTS4NpmA@mail.gmail.com>
 <20190618182733.GD26346@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d6b4f8b-c8ea-c120-0007-7d68698e5c4d@redhat.com>
Date:   Tue, 18 Jun 2019 21:17:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190618182733.GD26346@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/19 20:27, Borislav Petkov wrote:
> Right, and that right there looks wrong:
> 
> ICLASS    : VMLOAD
> CPL       : 3
> CATEGORY  : SYSTEM
> EXTENSION : SVM
> ATTRIBUTES: PROTECTED_MODE
> PATTERN   : 0x0F 0x01 MOD[0b11] MOD=3 REG[0b011] RM[0b010]
> OPERANDS  : REG0=OrAX():r:IMPL
> 
> That is, *if* "CPL: 3" above means in XED context that VMLOAD is
> supposed to be run in CPL3, then this is wrong because VMLOAD #GPs if
> CPL was not 0. Ditto for VMRUN and a couple of others.

This should not be related though, this is what syzkaller could place in
the guest but the reproducer is much simpler and the vmload fault is
happening genuinely in the host.

In particular, syz_kvm_setup_cpu's arguments are all zero so the guest
is basically doing nothing.

Paolo
