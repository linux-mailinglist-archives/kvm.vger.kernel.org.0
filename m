Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5333D42A
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 13:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhCPMrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 08:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhCPMqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 08:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7914165039;
        Tue, 16 Mar 2021 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615898791;
        bh=Ur86/kQH+7n2c1T3Xl1ln8o4FtX9RoHOK0NxalNWD8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=csjAgYsd3yGhqD4TtqAl+ZYjIzLIQDBHXkXrWz2H8IONUDfMqhqdUqtQcOyKR1I/O
         LkN3e5KvxbgC7R3Wi4zyjdAMeRk3YRGHNDNzDf4umO+OQID0waSfjE6/MsrVmudg2V
         tCPUcx6kWN/9ZhMCXRjxzAJHfyrM63FaKSLZ1M/ORSJlB+o9qtNbAxvmWXIebLryAR
         4X12nAzSlOeFN+vVYdeIpzYZk1c+Rhb+XzO7MT7LCLp6HPjuTTXSAbV/yyIKq8Prrz
         3+sfbo6UVDxz8s8WsVwWbLaKOT7qG10FHFfi8XmTrfdWUyYDko7UqowSZyZWM3YBtK
         NQM5dtN3ORBwQ==
Date:   Tue, 16 Mar 2021 14:46:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YFCojQmyM8fdGmnl@kernel.org>
References: <YE0NeChRjBlldQ8H@kernel.org>
 <YE4M8JGGl9Xyx51/@kernel.org>
 <YE4rVnfQ9y7CnVvr@kernel.org>
 <20210315161317.9c72479dfcde4e22078abcd2@intel.com>
 <YE9beKYDaG1sMWq+@kernel.org>
 <YE9mVUF0KOPNSfA9@kernel.org>
 <20210316094859.7b5947b743a81dff7434615c@intel.com>
 <YE/oHt92suFDHJ7Z@kernel.org>
 <YE/o/IGBAB8N+fnt@kernel.org>
 <YFAGUWDYacz1zroI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFAGUWDYacz1zroI@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 06:13:53PM -0700, Sean Christopherson wrote:
> On Tue, Mar 16, 2021, Jarkko Sakkinen wrote:
> > On Tue, Mar 16, 2021 at 01:05:05AM +0200, Jarkko Sakkinen wrote:
> > > The way I've understood it is that given that KVM can support SGX
> > > without FLC, vEPC should be available even if driver cannot be
> > > enabled.
> > > 
> > > This is also exactly what the short summary states.
> > > 
> > > "Initialize virtual EPC driver even when SGX driver is disabled"
> > > 
> > > It *does not* state:
> > > 
> > > "Initialize SGX driver even when vEPC driver is disabled"
> > > 
> > > Also, this is how I interpret the inline comment.
> > > 
> > > All this considered, the other direction is undocumented functionality.
> > 
> > Also:
> > 
> > 1. There is *zero* good practical reasons to support the "2nd direction".
> 
> Uh, yes there is.  CONFIG_KVM_INTEL=n and X86_FEATURE_VMX=n, either of which
> will cause vEPC initialization to fail.  The former is obvious, the latter is
> possible via BIOS configuration.

Hmm... So you make the checks as if ret != -ENODEV? That's the sane way to
deal with that situation IMHO.

/Jarkko
