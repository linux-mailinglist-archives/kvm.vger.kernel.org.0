Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B669A5B27C2
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIHUeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 16:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIHUeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 16:34:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121F1F02BB;
        Thu,  8 Sep 2022 13:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C784CB8227C;
        Thu,  8 Sep 2022 20:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED387C433D7;
        Thu,  8 Sep 2022 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662669253;
        bh=xznb1RKBZH/nj2qdZlu+dotoTsJWwyQbwBXQt70aXfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aV+WCP9SeYQN9/uvhmG0jzovy09Muqg0xuGb1GoH0fy5inl2zw+gC/19rPaudjVTv
         Qo4D2iAs145mScERTpLbx1ipWCp42F1k/TmKYdEy0zVX8N2TouAtODomu711xjWyyD
         r9zQKKZ27c8aU4m3/zaqB9d16l6a5SYVEuT/4IV/FCkJUxcUY0YgLo8BJCuW6f9VQX
         SB8uDzPG7QdXAZeSI7QoeSMtFbkxk8pQEpN/3ZBzrva2lAA61x0+Ohiq6EBiMBLKOe
         nujTj0rT4LvIcE38NM7aHZJ+TkhKsXHyavZoABrPJK+f/GAXRulwXDrepG26zyYclo
         zR1K6o6wyldXw==
Date:   Thu, 8 Sep 2022 23:34:07 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Harald Hoyer <harald@profian.com>, ashish.kalra@amd.com,
        ak@linux.intel.com, alpergun@google.com, ardb@kernel.org,
        bp@alien8.de, dave.hansen@linux.intel.com, dgilbert@redhat.com,
        dovmurik@linux.ibm.com, hpa@zytor.com, jmattson@google.com,
        jroedel@suse.de, kirill@shutemov.name, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        marcorr@google.com, michael.roth@amd.com, mingo@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com,
        rientjes@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        slp@redhat.com, srinivas.pandruvada@linux.intel.com,
        tglx@linutronix.de, thomas.lendacky@amd.com, tobin@ibm.com,
        tony.luck@intel.com, vbabka@suse.cz, vkuznets@redhat.com,
        x86@kernel.org
Subject: Re: [[PATCH for v6]] KVM: SEV: fix snp_launch_finish
Message-ID: <YxpRv14+glaFpGsF@kernel.org>
References: <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <20220908145557.1912158-1-harald@profian.com>
 <YxoGItJDTEjfctaS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxoGItJDTEjfctaS@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 03:11:30PM +0000, Sean Christopherson wrote:
> On Thu, Sep 08, 2022, Harald Hoyer wrote:
> > The `params.auth_key_en` indicator does _not_ specify, whether an
> > ID_AUTH struct should be sent or not, but, wheter the ID_AUTH struct
> > contains an author key or not. The firmware always expects an ID_AUTH block.
> > 
> > Link: https://lore.kernel.org/all/cover.1655761627.git.ashish.kalra@amd.com/
> 
> Please provide feedback by directly responding to whatever patch/email is buggy.
> Or if that's too complicated for some reason (unlikely in this case), provide the
> fixup patch to the author *off-list*.

I'd guess that'd be:

https://lore.kernel.org/all/6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com/

BR, Jarkko
