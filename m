Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696BC1B2BB7
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgDUP4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 11:56:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:44895 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgDUP4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 11:56:00 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 03LFtMkQ010973;
        Tue, 21 Apr 2020 10:55:22 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 03LFtG0c010964;
        Tue, 21 Apr 2020 10:55:16 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Tue, 21 Apr 2020 10:55:16 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/5] powerpc: Replace _ALIGN_DOWN() by ALIGN_DOWN()
Message-ID: <20200421155516.GT26902@gate.crashing.org>
References: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr> <3911a86d6b5bfa7ad88cd7c82416fbe6bb47e793.1587407777.git.christophe.leroy@c-s.fr> <CACPK8XfqnqgkXcBzp=nqd=AJX1MK05eTNiyOdaEuRu3_6RsXSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8XfqnqgkXcBzp=nqd=AJX1MK05eTNiyOdaEuRu3_6RsXSQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

On Tue, Apr 21, 2020 at 01:04:05AM +0000, Joel Stanley wrote:
> On Mon, 20 Apr 2020 at 18:38, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> > _ALIGN_DOWN() is specific to powerpc
> > ALIGN_DOWN() is generic and does the same
> >
> > Replace _ALIGN_DOWN() by ALIGN_DOWN()
> 
> This one is a bit less obvious. It becomes (leaving the typeof's alone
> for clarity):
> 
> -((addr)&(~((typeof(addr))(size)-1)))
> +((((addr) - ((size) - 1)) + ((typeof(addr))(size) - 1)) &
> ~((typeof(addr))(size)-1))
> 
> Which I assume the compiler will sort out?

[ This is line-wrapped, something in your mailer?  Took me a bit to figure
  out the - and + are diff -u things :-) ]

In the common case where size is a constant integer power of two, the
compiler will have no problem with this.  But why do so complicated?

Why are the casts there, btw?


Segher
