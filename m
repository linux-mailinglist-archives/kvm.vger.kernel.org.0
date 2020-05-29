Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0A51E8386
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgE2QVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:21:35 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:6135
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbgE2QVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:21:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz/RZspbvw8OfhMWtUvWnXXuPfFnQOvHZhKohkNyl7vBmRe2QbhCpLyj7Lb+KAGHKJq2FVrhixTJaVxW4EW+E+2P8FbTFm7SlDJ3jMEuGnYcB9xwgXkZelLkHdSO1abkF8VW7qUHf3P3/9EnnHa2ad/dM8DKOEVWl5lODFNGqs7sH9UhiyiPAswgYyLn0RdehkGmQJSIJjWnra+qs6okRRiKWAKFjl0iWa3uQRDowtCBT0KsnKqVRXBi7b4IvyOr1b8KVW+FSPIiXeLo8UFdxP1aDsm7LvxQ72gx4vGi85J0bQFdi0oyZm/gKV5Hx1xpdPdCN/PLEyi0QwOuMnYp6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LAKm20iE9r4lBDB29MQHEGYibDsEI9ORJo5U4iEEe3Y=;
 b=B45Xe+ES1eCAcwY9UB248nx1LwjHpPfgVRV15WFwcVX4cPGDh2d000AVz7yl6Fje/bg+Eb5CVJhmwi6AoCIut7qCFFGw84seferNyIPleckhMw71Dqo7Xh+IYIkqpHMhjp+NUmdPxZWLgILMDoccscntYD6NfYQR/WF1fcrJSO1Z03B0EGIOFM4Kc2YDxiKCevPnrqzf3qIVD00pzyJ+Ogh73Oep1ToU+ATHg8eHvY8FMTIh/rUS29A4cC2OcIenLBS0BtuVFBRaQloOjvLcrOkcfLRaDsOAryJskvlKvGt09RnLnqlazA8lpM6kIpzjD11Vafm+eVo+j8cliajXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LAKm20iE9r4lBDB29MQHEGYibDsEI9ORJo5U4iEEe3Y=;
 b=wViqDrxjV0WPJy6ovJXxXJaXgrHb8w+TYgnxyfiOfw9xcU91lcM7SfMA3kGRyXUu4HwNx+UqK0KUwp3eQs4fq+os/46DWuwCizOLMURz8QWjxT9jh1lGQRR1c9e6uZPElxZDK8+3JBEJg+0lmH9YI7+24y/r8hJMqquLODmC2eE=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2488.namprd12.prod.outlook.com (2603:10b6:4:b5::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Fri, 29 May 2020 16:21:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3021.030; Fri, 29 May
 2020 16:21:31 +0000
Subject: Re: [PATCH v3 69/75] x86/realmode: Setup AP jump table
To:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-70-joro@8bytes.org> <20200529090222.GA9011@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0b39f7af-f006-9563-9dbb-347f68cf492e@amd.com>
Date:   Fri, 29 May 2020 11:21:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200529090222.GA9011@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0047.prod.exchangelabs.com (2603:10b6:800::15) To
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0047.prod.exchangelabs.com (2603:10b6:800::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 16:21:29 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14e1fa45-b69e-4447-d0ed-08d803ec58a6
X-MS-TrafficTypeDiagnostic: DM5PR12MB2488:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2488B27EA016986929D7B357EC8F0@DM5PR12MB2488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9uS4DiPgYXVxLdZRBWaWhDcg99mK+WNI2KwfJF2WmDGn9hbgsxtSq6xLX7ZRXkE2oThsb7GYvNOVoqmogeCb9zRj2EvbljXx5fMP/gKcahv3UqK08U2UnzFhj5YbZ1KdmBMLABigKhHvut4l08sqf/XbYvxu42JnCIVLyPB9f2wjvaKWVzWevpYPIUwQ49J/6OhbuT49RPY5f3E5Md+9P12jmi+mZ3jz7SE4Z4r7xNvePOEyM/33BZjdZBe1hNH4BARdNcAheVd7T2hyHEyonM0f0gzuwGE6ppSFVzG4NfZrPQWIA4lhznP+RIZZzYb7dIwGF8GsdEbjSQlEwWiA44U3aGk37FCO/xCznOdwu+wz0zirT2nPbNHbjS7OswHU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(4326008)(53546011)(6506007)(52116002)(86362001)(8936002)(110136005)(956004)(7416002)(54906003)(478600001)(2616005)(2906002)(316002)(8676002)(6486002)(36756003)(6512007)(26005)(31696002)(83380400001)(5660300002)(66946007)(66476007)(31686004)(66556008)(186003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YBb6c5xlgEidgXptBaoAhtZqmRWeNvYldvoYAG1L3SLB0Qy3b2jYml2pI4t+7rGkM/F5bnosBLJOW0QD3cQJMhvEFfU1bwY54arrhctGkLr3kQAigpXhyd/6X1GRVYJmXh5Sj+zovlzE+rR0+/6kmqAJNsPRGZ1pHGPrz9jxDnbOYl4g+7W39D5WWgJMyR2JSLlhrGg10LoYw3lmEIp56ccjaj/LyImYaUmDhqVjoSzz/eYEjU1KgSQN2Xed0rj+cjTQ73h95kVeJ479BxIgMOBwSCPb9sj+EXkVuqVwivf34Y6KsZyR2KNjyTbDfgKieKZw5LcTLvUdLsR+jjNfjregq370Q5047AB7n/O1n2AHdeeUfWnqDzJqkk5Kf7RBvcvNPDbnwNULBcp1Vq13G+90Gkl89FoPsBk4z0f1lGnoPcEAeGHg+ZDWEYpcGayQkyH0aMdFYIuOzwudlk9GGGj65Ca62+E1SfMp7tt6IKQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e1fa45-b69e-4447-d0ed-08d803ec58a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 16:21:31.0756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wh+bkmbuE1LNX1iCRDoZHDVf52SL//mNy4T7pQ5yRxjMF1PPXGAdf9WQiOeuhoMoVCJgnrFLFa3s2kbCvAQBqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2488
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/29/20 4:02 AM, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:17:19PM +0200, Joerg Roedel wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Setup the AP jump table to point to the SEV-ES trampoline code so that
>> the APs can boot.
> 
> Tom, in his laconic way, doesn't want to explain to us why is this even
> needed...
> 
> :)

Looks like some of the detail was lost during the patch shuffling. 
Originally (on GitHub) this was the text:

  As part of the GHCB specification, the booting of APs under SEV-ES
  requires an AP jump table when transitioning from one layer of code to
  another (e.g. when going from UEFI to the OS). As a result, each layer
  that parks an AP must provide the physical address of an AP jump table
  to the next layer using the GHCB MSR.

  Upon booting of the kernel, read the GHCB MSR and save the address of
  the AP jump table. Under SEV-ES, APs are started using the INIT-SIPI-SIPI
  sequence. Before issuing the first SIPI request for an AP, the start eip
  is programmed into the AP jump table. Upon issuing the SIPI request, the
  AP will awaken and jump to the start eip address programmed into the AP
  jump table.

It needs to change "GHCB MSR" to "VMGEXIT MSR protocol", but should cover 
what you're looking for.

Thanks,
Tom

> 
> /me reads the code
> 
> /me reads the GHCB spec
> 
> aha, it gets it from the HV. And it can be set by the guest too...
> 
> So how about expanding that commit message as to why this is done, why
> needed, etc?
> 
> Thx.
> 
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 262f83cad355..1c5cbfd102d5 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -9,6 +9,7 @@
>>   #include <asm/realmode.h>
>>   #include <asm/tlbflush.h>
>>   #include <asm/crash.h>
>> +#include <asm/sev-es.h>
>>   
>>   struct real_mode_header *real_mode_header;
>>   u32 *trampoline_cr4_features;
>> @@ -107,6 +108,11 @@ static void __init setup_real_mode(void)
>>   	if (sme_active())
>>   		trampoline_header->flags |= TH_FLAGS_SME_ACTIVE;
>>   
>> +	if (sev_es_active()) {
>> +		if (sev_es_setup_ap_jump_table(real_mode_header))
>> +			panic("Failed to update SEV-ES AP Jump Table");
>> +	}
>> +
> 
> So this function gets slowly sprinkled with
> 
> 	if (sev-something)
> 		bla
> 
> Please wrap at least those last two into a
> 
> 	sev_setup_real_mode()
> 
> or so.
> 
