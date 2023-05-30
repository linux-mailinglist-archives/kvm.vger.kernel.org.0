Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623F1716AAE
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 19:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbjE3RTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjE3RTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 13:19:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882F898;
        Tue, 30 May 2023 10:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685467158; x=1717003158;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=tBS8QRmW7FiYudJqYJWqWxLyyCAH9w7Efz2ctqMQaCM=;
  b=cMdEi0CikShWIoZL/6tXfuMaSbS9/vATA33iXN1QMWXk10xv8hPuXUUA
   XRlgUtZ3H+gpdXqfIwTnx5VEB33ocKIq+OVdF5uODlewSQ7ucBczx91Bl
   uGq5UEU2R/vMR8C9mvaQrBUqVO2+jD1IWrak9D+d1fszmhrHxF9g/A/9r
   q8FI5DRtPeRT9a/j9+7AqE5jUHASzpd7TYrW6d/XdA/7GsAPAF1V48LSo
   7aG1+SP3PvAzgN3Uz0xRslSnFPc8fKOCwxmyUNxU9hFH82D8VzC7x4lJh
   fnJnwAcY7Xauib82ZY4wOrDtUgEh6cQ4P8xASgJ9tel/h1lwZY63cgRq1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441345315"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="441345315"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 10:19:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="684061909"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="684061909"
Received: from jswalken-mobl.amr.corp.intel.com (HELO [10.212.134.46]) ([10.212.134.46])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 10:19:17 -0700
Message-ID: <ce2badca-089d-34de-c929-075fe75fc0e9@intel.com>
Date:   Tue, 30 May 2023 10:19:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] x86/msr: Allow unprivileged read access to some MSRs
Content-Language: en-US
To:     Tim Wiederhake <twiederh@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <20230523194949.96149-1-twiederh@redhat.com>
 <20230530102358.16430-1-twiederh@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230530102358.16430-1-twiederh@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/23 03:23, Tim Wiederhake wrote:
> Expose some non-security sensitive MSRs through sysfs to allow access
> for unprivileged processes. This also helps other programs that are
> interested in IA32_EFER for x86-64-v1 detection.

Did you mean "sysfs" or "sysctl"?

I'm still on the fence about whether we should do this.  This seems
_marginally_ better than the /dev approach.

But whatever we do we need some *VERY* explicit, tight rules about what
can be exposed via this interface in the future.  We absolutely can't
have folks adding to this in the future without following those rules.

A lot of this is implicit in the implementation and even the ABI, but
let's say them out loud, please:

  * The MSRs must be read-only.  If they are read-write, the snapshot
    can get out of date. This can be guaranteed by either:
   * Never being written at runtime after they are snapshotted, or
     preferably:
   * Being defined to be read-only (wrmsr just doesn't work)
  * The MSRs must be have the same exact value on all CPUs (because
    there is only one file per MSR)
  * The value must be static.  Not only read-only from the software
    point of view, but the hardware and hypervisor must also promise not
    to change it.

The first two seem doable.  I'm not sure how we deal with the third,
though, especially in the case of microcode updates or clever hypervisors.
