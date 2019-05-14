Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFA1C3D3
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfENH3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:29:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59736 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfENH3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LyILN8tiqYOrBbTwx/bEvqalqGDEJJBbWfhDeckm5hE=; b=Dzz9eun9Mdy9wxo6bjQ/SIsbt
        oaxyTesAJhv9qhYG29ELdIzQ8B/4GLPi0S8UY+SnAcrWsieohzt9xVLpRhitf05XQyxO7ZvDUpA0D
        cS8cXr+iCRBYbcZyZ7yfxlixVscm0v/7u4FMWGSfjFQof4+63mREl05GW8UbuYtl0yzm5KhC518wa
        3K0+dFcGdKuj0Q3+Da79oPBpMcssZqcdi8szEOuBHxkpbs5D9EZOYRhpClyX/WmZZ7XT/F5ssJ6Il
        DBeWy+3TfcJ/0K1sCsfibvbpOdBb6QU26+YWbFL59jn27d7emM4RUrVU80JjsfqyYCnyCGrQaB3VT
        WW2asI+rg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQRsd-00054W-Bb; Tue, 14 May 2019 07:29:43 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B13822029F87A; Tue, 14 May 2019 09:29:41 +0200 (CEST)
Date:   Tue, 14 May 2019 09:29:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
Message-ID: <20190514072941.GG2589@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
 <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


(please, wrap our emails at 78 chars)

On Tue, May 14, 2019 at 12:08:23AM +0300, Liran Alon wrote:

> 3) From (2), we should have theoretically deduced that for every
> #VMExit, there is a need to kick the sibling hyperthread also outside
> of guest until the #VMExit is completed.

That's not in fact quite true; all you have to do is send the IPI.
Having one sibling IPI the other sibling carries enough guarantees that
the receiving sibling will not execute any further guest instructions.

That is, you don't have to wait on the VMExit to complete; you can just
IPI and get on with things. Now, this is still expensive, But it is
heaps better than doing a full sync up between siblings.


