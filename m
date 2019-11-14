Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAAAFC14D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 09:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfKNINg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 03:13:36 -0500
Received: from thoth.sbs.de ([192.35.17.2]:39146 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfKNINg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 03:13:36 -0500
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id xAE8DNNI008618
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 09:13:23 +0100
Received: from [167.87.46.11] ([167.87.46.11])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id xAE8DM5G023544;
        Thu, 14 Nov 2019 09:13:22 +0100
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <20191113232510.GB891@guptapadev.amr>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <671b49ab-f65d-8b44-4da6-137d05cd1b9c@siemens.com>
Date:   Thu, 14 Nov 2019 09:13:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191113232510.GB891@guptapadev.amr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.11.19 00:25, Pawan Gupta wrote:
> On Wed, Nov 13, 2019 at 09:23:30AM +0100, Paolo Bonzini wrote:
>> On 13/11/19 07:38, Jan Kiszka wrote:
>>> When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
>>> couldn't simply be handled by the host. But I suppose the symptom of
>>> that erratum is not "just" regular recoverable MCE, rather
>>> sometimes/always an unrecoverable CPU state, despite the error code, right?
>>
>> The erratum documentation talks explicitly about hanging the system, but
>> it's not clear if it's just a result of the OS mishandling the MCE, or
>> something worse.  So I don't know. :(  Pawan, do you?
> 
> As Dave mentioned in the other email its "something worse".
> 
> Although this erratum results in a machine check with the same MCACOD
> signature as an SRAR error (0x150) the MCi_STATUS.PCC bit will be set to
> one. The Intel Software Developers manual says that PCC=1 errors are
> fatal and cannot be recovered.
> 
> 	15.10.4.1 Machine-Check Exception Handler for Error Recovery [1]
> 
> 	[...]
> 	The PCC flag in each IA32_MCi_STATUS register indicates whether recovery
> 	from the error is possible for uncorrected errors (UC=1). If the PCC
> 	flag is set for enabled uncorrected errors (UC=1 and EN=1), recovery is
> 	not possible.
> 

And, as Dave observed, even that event is not delivered to software 
(maybe just logged by firmware for post-reset analysis) but can or does 
cause a machine lock-up, right?

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
