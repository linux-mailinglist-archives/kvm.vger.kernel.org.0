Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0C6407B1
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 14:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiLBNcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 08:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBNcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 08:32:05 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14778B0A25
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 05:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669987925; x=1701523925;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MEmy1c2bcyQx22F6dyR4ES4N7vulay3pIVGahBoVD0k=;
  b=l3OL6YIWIMMuGaQMVejdro1QykOmPf8xbwTYNvTGvZzZChEVSJ3YO3Ce
   HMhYzSX3cEr3ruynFhFyXdZ+6sZmdrkTiKmgIVFZR0lRNfJVYJ+yxDbCv
   vIjdhYNfBjSbHYhb0KwuraQAVcRodEuVGdaeg1MtLMKU4lut7lAtXgewt
   1bqJHYvA3W7C2B3BmxksdW0fcwe6AdKtIXwpvAzmODzn/iUY/zj2wXUzh
   9nGnQt6GH60fST05PpNo7Ek+pnlsX/tBTSQht573Pv4JL+pQ/WYBgK339
   UMqbCiSKr+bLauAmFOSPdNrdFJ1LBXx9odLitDny9E1mhV+8M3clxU2ff
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402233408"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="402233408"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 05:32:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="769606535"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="769606535"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2022 05:32:01 -0800
Message-ID: <0022a85f16c1f1dc14decdc71f58af492b45b50d.camel@linux.intel.com>
Subject: Re: [PATCH v3 2/3] KVM: keep track of running ioctls
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Date:   Fri, 02 Dec 2022 21:32:01 +0800
In-Reply-To: <22042ca5-9786-ca2b-3e3d-6443a744c5a9@redhat.com>
References: <20221111154758.1372674-1-eesposit@redhat.com>
         <20221111154758.1372674-3-eesposit@redhat.com>
         <c7971c8ad3b4683e2b3036dd7524af1cb42e50e1.camel@linux.intel.com>
         <22042ca5-9786-ca2b-3e3d-6443a744c5a9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-02 at 13:03 +0100, Emanuele Giuseppe Esposito wrote:
...
> > > @@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type,
> > > ...)
> > >      va_end(ap);
> > >  
> > >      trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
> > > +    accel_cpu_ioctl_begin(cpu);
> > 
> > Does this mean that kvm_region_commit() can inhibit any other vcpus
> > doing any ioctls?
> 
> Yes, because we must prevent any vcpu from reading memslots while we
> are
> updating them.
> 
But do most other vm/vcpu ioctls contend with memslot operations?

