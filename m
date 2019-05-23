Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1154275D8
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 08:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfEWGGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 02:06:52 -0400
Received: from 9.mo179.mail-out.ovh.net ([46.105.76.148]:35908 "EHLO
        9.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfEWGGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 02:06:52 -0400
Received: from player688.ha.ovh.net (unknown [10.108.57.245])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id C52A41300BF
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 08:06:49 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player688.ha.ovh.net (Postfix) with ESMTPSA id D3CD95FC343E;
        Thu, 23 May 2019 06:06:45 +0000 (UTC)
Subject: Re: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU and
 RAM limits
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org
References: <20190520071514.9308-1-clg@kaod.org>
 <20190522233043.GO30423@umbus.fritz.box>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <10ae32dc-a103-e523-1da2-a5ebedf9432f@kaod.org>
Date:   Thu, 23 May 2019 08:06:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522233043.GO30423@umbus.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4069283740144536455
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddufedguddtjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/19 1:30 AM, David Gibson wrote:
> On Mon, May 20, 2019 at 09:15:11AM +0200, Cédric Le Goater wrote:
>> Hello,
>>
>> Here are a couple of fixes for issues in the XIVE KVM device when
>> testing the limits : RAM size and number of vCPUS.

This summary is wrong. RAM size was fixed in QEMU.

> How serious are the problems these patches fix?  I'm wondering if I
> need to make a backport for RHEL8.1.

Patch 1 is a cleanup patch. It does not fix any critical issues.

Patch 2 fixes CPU hotplug. The test on the EQ flag is at the wrong 
place :/ This is important I think.

Patch 3 fixes the maximum number of vCPUS supported. This one is 
less important maybe, unless we want to run a guest with 1024 vCPUs.
Which is quite slow to run on most P9 systems. 

QEMU emits a warning :

  warning: Number of SMP cpus requested (1024) exceeds the recommended cpus supported by KVM (120)

May be we should refuse to run QEMU when that number is above a 
certain threshold ? 

C. 



>>
>> Based on 5.2-rc1.
>>
>> Available on GitHub:
>>
>>     https://github.com/legoater/linux/commits/xive-5.2
>>
>> Thanks,
>>
>> C. 
>>
>> Cédric Le Goater (3):
>>   KVM: PPC: Book3S HV: XIVE: clear file mapping when device is released
>>   KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
>>     reseting
>>   KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
>>     identifier
>>
>>  arch/powerpc/kvm/book3s_xive_native.c | 46 ++++++++++++++++-----------
>>  1 file changed, 27 insertions(+), 19 deletions(-)
>>
> 

