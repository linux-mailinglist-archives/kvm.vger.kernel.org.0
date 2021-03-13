Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8493339F41
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 17:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhCMQym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 11:54:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:64049 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233635AbhCMQym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 11:54:42 -0500
IronPort-SDR: XHwBZlFY/Szwfaecu1Fnj9dy6hsWuALE4JNeTMJU8Nrmfr3cLuGNn6aCCzYzPJYZh/ZSxTiH0j
 hyufNr9HmLUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9922"; a="189040915"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="189040915"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2021 08:54:41 -0800
IronPort-SDR: q+dZ4Wdw1KWvvWQuaBlglJ3vdF/LGB5BBKjuN9QbvctfyF6y/4AbdDbUELjkR9dOXXCNvcfIBx
 p7xtDLTWeL8w==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411366510"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2021 08:54:41 -0800
Date:   Sat, 13 Mar 2021 08:57:01 -0800
From:   Jacob Pan <jacob.jun.pan@intel.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        jacob.jun.pan@intel.com
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <20210313085701.1fd16a39@jacob-builder>
In-Reply-To: <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
        <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
        <20210312125821.22d9bfca@jacob-builder>
        <YEvZ4muXqiSScQ8i@google.com>
        <20210312145904.4071a9d6@jacob-builder>
        <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tejun,

On Sat, 13 Mar 2021 05:20:39 -0500, Tejun Heo <tj@kernel.org> wrote:

> On Fri, Mar 12, 2021 at 02:59:04PM -0800, Jacob Pan wrote:
> > Our primary goal is to limit the amount of IOASIDs that VMs can
> > allocate. If a VM is migrated to a different cgroup, I think we need to
> > charge/uncharge the destination/source cgroup in order enforce the
> > limit. I am not an expert here, any feedback would be appreciated.  
> 
> That simply isn't a supported usage model. None of other resources will
> get tracked if you do that.
Isn't PIDs controller doing the charge/uncharge? I was under the impression
that each resource can be independently charged/uncharged, why it affects
other resources? Sorry for the basic question.

I also didn't quite get the limitation on cgroup v2 migration, this is much
simpler than memcg. Could you give me some pointers?

BTW, since the IOASIDs are used to tag DMA and bound with guest process(mm)
for shared virtual addressing. fork() cannot be supported, so I guess clone
is not a solution here.

Thanks,

Jacob
