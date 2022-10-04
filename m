Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310DA5F48DA
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJDRp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 13:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJDRpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 13:45:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DAAB1E7;
        Tue,  4 Oct 2022 10:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664905497; x=1696441497;
  h=message-id:date:mime-version:from:to:subject:
   content-transfer-encoding;
  bh=NTKKHeoEYZWSl1Ry7nAI5w9pUYcyarim9OndgbtenE4=;
  b=nC60IhX0iXMQ2eHdvjvmwLh3QG/4oEOC93JUaJJItfCcH0Q1sf9L5OoA
   Tr9dB11S6ZFNuA4nJwQwWAHm4GVEwVbA3lcXvciF6ARK1prcaIyAnl0CB
   yHVx72PTa22w0rCQS+eWXZU+OUK27x8cKQv66jzHknJEPPmbFzVxA52+i
   sgW4wY7ACKIEKSWLPynCkkYWt4/7WZAqJduNeaBl3HEjRlu+sTKZbWjhj
   u9CTiddqKEdXrwMrmosm5pAx/Ya6wHTL1BfMhxmbBIZ3efk8iyWjT5/0q
   YwtW4c+T8cHTPo/BjR3AtMluMy9rBUKUxF3Pw9R6dvEmMO+Ga/+Qy0MNd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="290213451"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="290213451"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 10:34:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="601706208"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="601706208"
Received: from samrober-mobl.amr.corp.intel.com (HELO [10.209.85.136]) ([10.209.85.136])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 10:34:11 -0700
Message-ID: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
Date:   Tue, 4 Oct 2022 10:34:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
From:   Dave Hansen <dave.hansen@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Finish removing MPX from arch/x86?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We zapped the userspace MPX ABIs and most of its supporting code in here:

	45fc24e89b7c ("x86/mpx: remove MPX from arch/x86")

But, the XSAVE enabling and KVM code were left in place.  This let folks
at least keep running guests with MPX.

It's been a couple of years and I don't think I've had a single person
opine about the loss of MPX.  Intel also followed through and there's no
MPX to be found on newer CPUs like my "Tiger Lake" 11th Gen Intel(R)
Core(TM) i7-1165G7.

Is it time to zap MPX from arch/x86/kvm/?
