Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E47A4CC9
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjIRPks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjIRPko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:40:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CADFC;
        Mon, 18 Sep 2023 08:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=XYZRHs0p/FMaKDD4jecbFxZVy3DXCvr3GOvUaH+nvWE=; b=SnOACfvHrRzPMC4goTXMpBR5cm
        saYnBnGyRHJ2rvvxeS84D4/j9ufP1KrZResbTQ6pLykCWbCBZlAfsFhmWa1NCduEtGm4lyeeaChrE
        IY0NDCLoSX9JF6i/kbqYbAYGFsDRPWBnh3lzq/Ci4ylddEa1rjNCBm8+J9weqsbLcQXrx5JoDsxrf
        FghbzcLgUxBCW5JCFpXEpdYzhaUIGo603ZHhN4//Yv5XcP/kIT6NzfFFH7k52qrw3dHyUoUHuiRd4
        IKlccJ1iYDF4xb2w1LZFK53XBBGDszwIWUbDN5WjUw8Fqqwx+EVDrpwPuhcsABDunlDeB8lLspvIG
        eF8T+IqA==;
Received: from [2a00:23ee:2830:116e:a875:a49a:29fd:de50] (helo=[IPv6:::1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qiEsk-00BPSw-5o; Mon, 18 Sep 2023 14:05:51 +0000
Date:   Mon, 18 Sep 2023 15:05:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     paul@xen.org, Paul Durrant <xadimgnik@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
CC:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_11/12=5D_KVM=3A_selftests_/_xen=3A?= =?US-ASCII?Q?_don=27t_explicitly_set_the_vcpu=5Finfo_address?=
User-Agent: K-9 Mail for Android
In-Reply-To: <f5eab713-fa74-2cbc-7df5-81d8d26fee0a@xen.org>
References: <20230918112148.28855-1-paul@xen.org> <20230918112148.28855-12-paul@xen.org> <f649285c0973ec59180ed51c4ee10cdc51279505.camel@infradead.org> <56dad458-8816-2de5-544e-a5e50c5ad2a2@xen.org> <c9a1961812b0cbb6e9f641dec5c6edcb21482161.camel@infradead.org> <f5eab713-fa74-2cbc-7df5-81d8d26fee0a@xen.org>
Message-ID: <425F7A5D-58D1-4D94-A88C-E7B1EAEAD084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18 September 2023 14:41:08 BST, Paul Durrant <xadimgnik@gmail=2Ecom> wr=
ote:
>Well, if the VMM is using the default then it can't unmap it=2E But setti=
ng a vcpu_info *after* enabling any event channels would be a very odd thin=
g for a guest to do and IMO it gets to keep the pieces if it does so=2E


Hm, I suppose I'm OK with that approach=2E The fact that both VMM implemen=
tations using this KVM/Xen support let the guest keep precisely those piece=
s is a testament to that :)

But now we're hard-coding the behaviour in the kernel and declaring that n=
o VMM will be *able* to "fix" that case even if it does want to=2E So perha=
ps it wants a modicum more thought and at least some explicit documentation=
 to that effect?

And a hand-wavy plan at least for what we'd do if we suddenly did find a r=
eason to care?
