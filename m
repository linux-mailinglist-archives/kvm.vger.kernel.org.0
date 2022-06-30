Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D78561972
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiF3Lpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiF3Lpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:45:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C11658FC0;
        Thu, 30 Jun 2022 04:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656589533; x=1688125533;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2mX4uYFYckU+u5d/5B4pwRiefLjn+1g7/6dyINaE9Kw=;
  b=S1VE8R0HmSx7JxfM2Z/gO2Qu7LKHrdGv39K8EPfhANpHn6LTZgB5pyof
   8vIpyiSQf0DxiiThX+KE8QFMx1GMrkKZVLb1uAmKBRGrlryNs50hsoCza
   Kli8I6pGWxCEHQJ3eE+sZKLe96bBaaF6bla46843JzLe8NtuhozR3gol7
   icnPgBqmMWyCnvF3PGNbWYpk+yDtRC/60XoHeB/Q/9qpf7gBSBb5Ar7p1
   l3SJJrL5w0PWAiO1G6uwjUi3t9rGV9OtJqt/zIK889JadWB4tsEILjtMl
   IUsL9Un9iwQnczPaiq7COs9pDqzC9KrL1cE+Bidcxb/rILokniy8wMCn0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="265359536"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="265359536"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:45:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="617949573"
Received: from zhihuich-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.49.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:45:31 -0700
Message-ID: <c7d290bcca7bf5f78aee523c43df11b506eada89.camel@intel.com>
Subject: Re: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask
 on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 30 Jun 2022 23:45:29 +1200
In-Reply-To: <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> TDX will use a different shadow PTE entry value for MMIO from VMX.=C2=A0 =
Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.=C2=A0 By using the per-VM EPT entry value for MMIO, the existi=
ng VMX
> logic is kept working.
>=20
> In the case of VMX VM case, the EPT entry for MMIO is non-present PTE
> (present bit cleared) without backing guest physical address (on EPT
> violation, KVM searches backing guest memory and it finds there is no
> backing guest page.) or the value to trigger EPT misconfiguration.=C2=A0 =
Once
> MMIO is triggered on the EPT entry, the EPT entry is updated to trigger E=
PT
> misconfiguration for the future MMIO on the same GPA.=C2=A0 It allows KVM=
 to
> understand the memory access is for MMIO without searching backing guest
> pages.). And then KVM parses guest instruction to figure out
> address/value/width for MMIO.
>=20
> In the case of the guest TD, the guest memory is protected so that VMM
> can't parse guest instruction to understand the value and access width fo=
r
> MMIO.=C2=A0 Instead, VMM sets up (Shared) EPT to trigger #VE by clearing
> the VE-suppress bit.=C2=A0 When the guest TD issues MMIO, #VE is injected=
.=C2=A0 Guest VE
> handler converts MMIO access into MMIO hypercall to pass
> address/value/width for MMIO to VMM. (or directly paravirtualize MMIO int=
o
> hypercall.)=C2=A0 Then VMM can handle the MMIO hypercall without parsing =
guest
> instructions.

This is an infrastructural patch which enables per-VM MMIO caching.  Why no=
t
putting this patch first so you don't need to do below changes (which are
introduced by your previous patches)?

[...]

> =C2=A0
> -		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
> +		if (!is_shadow_present_pte(spte) ||
> +		=C2=A0=C2=A0=C2=A0 is_mmio_spte(vcpu->kvm, spte))
> =C2=A0			break;
> =C2=A0
>=20

[...]

> @@ -1032,7 +1032,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, =
struct kvm_mmu_page *sp)
> =C2=A0		gfn_t gfn;
> =C2=A0
> =C2=A0		if (!is_shadow_present_pte(sp->spt[i]) &&
> -		=C2=A0=C2=A0=C2=A0 !is_mmio_spte(sp->spt[i]))
> +		=C2=A0=C2=A0=C2=A0 !is_mmio_spte(vcpu->kvm, sp->spt[i]))
> =C2=A0			continue;

