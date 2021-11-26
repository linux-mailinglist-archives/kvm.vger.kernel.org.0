Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03F145E789
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 06:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344232AbhKZFut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 00:50:49 -0500
Received: from mail-sn1anam02on2095.outbound.protection.outlook.com ([40.107.96.95]:35781
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244112AbhKZFss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 00:48:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVlJyqNMjvAelPM0TwA65ewVOu/gdyDCDBA7hhPGURUrYQpy9qL+NO5J31S72fqwM6u5OU5PLXlsuKm/99+slzDqC3S0ytS/IkMeVcAGTeNVc3IJ1gAD0gyk8VCOAOk7CFBxgta4P0ho5KgWfSGW+EJ6lVAFtiviJgZiZRQryu0K2OUIINqw+B0GL46xG7l1xaG+1V9BE8fH6B37BPNFt/MfXe9y3ZLrJ993Y4E/euWsREa6O8wG1yIJ5bhzg5aWrVPu1SqLpFCMV+uZ7bhyJsZrg9DsWsK9oVe2PPoc/JRxAzFYgnKgbC9o+w0tILdrFLJQAgUH6H+LdTDrDh83yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfmSr2jdr9HurPszsjxiFpAGEV7xiwpgsuhTefFOK5c=;
 b=g4tlPBhGfNLdjfDhRh5R/dw5+2FrHYLOrbkIS/Hj3Dkt2RW9DA5NJZfae1d/rswovTn7Sg1Vi1ymxUDgHLlTLtRIC5VB4JhqGIftXRrG84PyYibGv54iF2j8MdBfHxpgJtOscEyrgfFYoqMnuZTDrAZHv4u+N68NtllTkv0Eq4/1v4uTBVbZgOJt5awoewx+HwMHxlTmcw7QJiyR2REGdezaznvjs1sU9AOrf+V3RstZMmJw5QbZxhRvrNMR82MUL04Q2b1nUGUB7sdNkKyIuu4FIiNcjcSxL46+a2NHwxhzhQ3J3Y8sK+TxgSUSwFN5fu2jCzGhOAWvixg7GbCLew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfmSr2jdr9HurPszsjxiFpAGEV7xiwpgsuhTefFOK5c=;
 b=qv5uBEqGegm0HI7hPXgIuzIJIDwHDJucA3kLYzynuMwUclNSZePbI+abI36UoHiyAQeLec13hAZCc0Mpmo0VZccDHm9cBiOfHQdkK4ZwsYkOpX3LfUGxSpiPmnScCHQjMxsTlvmtidVTDuQEGROzRUWGwiU7H+i5LFo1Ub6GrMQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB3786.prod.exchangelabs.com (2603:10b6:5:82::27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.19; Fri, 26 Nov 2021 05:45:34 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 05:45:33 +0000
Message-ID: <84b7602f-93c1-74e3-bebf-23ed9e795b9b@os.amperecomputing.com>
Date:   Fri, 26 Nov 2021 11:15:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] KVM: arm64: Use appropriate mmu pointer in stage2
 page table init.
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        Quentin Perret <qperret@google.com>,
        D Scott Phillips <scott@os.amperecomputing.com>
References: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
 <20211122095803.28943-2-gankulkarni@os.amperecomputing.com>
 <87bl28cpko.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87bl28cpko.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:610:59::24) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from [192.168.1.22] (122.177.58.155) by CH2PR03CA0014.namprd03.prod.outlook.com (2603:10b6:610:59::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 05:45:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fa72d2b-6ce9-454d-8725-08d9b09ff6a1
X-MS-TrafficTypeDiagnostic: DM6PR01MB3786:
X-Microsoft-Antispam-PRVS: <DM6PR01MB378678FF1E054D054539C64C9C639@DM6PR01MB3786.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aM9UHgThNwbTvfC162xi3gR+5q9nAx5+h8PwxjrQomT3cIZ79pcm/ByTWUJetG2v2iTImFqL2Q8OVy3IlzZPDSPIveqk524WJ+oNW7MWpadrg8O6vsslbGmg/bKEvnIqVZkNL3qw54OU7RIMD7q9+hLbBE2oJ5m8wFI1HraenE4tq1EDcmEmSJxJm+QOfspMEEInUfivE/hM4lhA26A4/LpodIF26BLoVVBQKWRkuPvyV0kAUcTBYUJ8q46GRzqGA/2LmoQsT6CPybGbPB0V30zbTV0//7UaGDl7CbK/DXzqrqeCcYwENFXoO2Xhlbc1lhoDqQsYr+irO+VzvRz6XZ1hTzwcUtOuZCL8YE+1AKy5HoMfhXZX/30SBECqIq5bctLb83Xue4R83HVXqjXvIlAl0wL7LJkGfOrvC0nZfr0ktGMSI+dviNdR804PjE/MyKqZWF4D7rO0YqqbFw1CGU/ohbd0S5uRCllh2oKrCNOJK3bmhjxQxn700ebrGt4h/BccGx93yc4bvmLdz9mN6grywfmj96BRBFslBZNPgJn4MGpK14jmTpu7WRF7YC3LNougvcSYdff2tR07zDvfD/UKP0D1jQmZhNvcDcpQPAV37Fs7Mf0dO7k4ZPVi9gA3SZF0Z14hnhzAytd2WG9S2/hX2b6IJDnE5+iN0SvA1ot3vpLR5ulSkUnKqs8GeYJqcBBV7z2E04mzam94uO57sfynN1WVaO0frpBF5uxlX6752vuHUbztpjSx0F64g8ETJu9J2UT6e7Gmy3oulMsWJdf0DP1aCTl6RgdZIBCBhlsolVlmX7Z6GrzQgBwuf3hoGTYxgnKHYvyuUBtoeGXXTSYrJac9tsC38X9XzrMGVG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(86362001)(38350700002)(38100700002)(107886003)(52116002)(5660300002)(8676002)(83380400001)(956004)(31696002)(6916009)(53546011)(2616005)(8936002)(2906002)(55236004)(6486002)(16576012)(66476007)(66556008)(66946007)(186003)(6666004)(4326008)(26005)(54906003)(966005)(508600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1NvelVtOU9aeUJVMGtISkxROWhlOGY5WEpiNURCSWdOV0lKTHhuY2ZyTXQ5?=
 =?utf-8?B?ZnBwdU1CMEZycXVEZWZKMUU1dk5vYUs2MUlKWnlKZmVXTmlaS3o5SXZIOGMy?=
 =?utf-8?B?YTFHRFl3T1pSRHNrVGpzRVcwSUlyS0FGdXBDcnNGMUlQTllWQ1BTNnBBR0dQ?=
 =?utf-8?B?dkV1SnExdE4rVjQ0MURtcjREK2owSTVMazZsKyt5U3pmYVY2QWVZdDduWlZI?=
 =?utf-8?B?R2N3b3R5YkNYM09vTVNVYnM1dEZmTlZ2OU8vRFhiT1FGM3BLMmlPckJLTnpU?=
 =?utf-8?B?ckZCdWx0V0crNHduTmdacE5IMXhRQlVoUGljOGZ1dDMvTERhRUhJWnpqZWJx?=
 =?utf-8?B?YnN6NDFzMGFUZUpURHRhSng0NmZJb1N5dGgrL3pLNHpISmdoVldqcmdmOThm?=
 =?utf-8?B?ZEpwak03aExKQzROYjJDWGdGNnFPQWdTQjc4Y0l0UnpZYUlQV0JVbTB6a1Zs?=
 =?utf-8?B?cDBscGYwYXVacVYvTFZlNU02eERSQ1grU2FXVDRuOGFyNDRrcHVKK3Q5ZWVO?=
 =?utf-8?B?YjNZSEs3R3F4eTNVQ1Y4N1FMWExibDR6KzEvQ2I4YlMrcVdXdmo1Sk5taXk0?=
 =?utf-8?B?SkV3bmRJdEpWa2cvZ3lXUkEvdkRQTW5SS0JYMmprSXVFRWx0QmRrS1lBcGpi?=
 =?utf-8?B?R3RNTFBTYTlCSnNBSlgrT2FKaU5qVEsrK0xja3FvODVDS3dYT2x0WmwvdnpH?=
 =?utf-8?B?dHZnR3A0RytrdFpoRVczSTdpY0Q5TUh3K0p5VU14ODA0dUJVdlJwd1dheTBj?=
 =?utf-8?B?b0Q3eXRnYWVEN3JidnJNWXI4KzlIWlNvSHZaOS9ZVHRvWXgyMVljL0NqUlhV?=
 =?utf-8?B?U0dzWVBuUGJUaC93Z0hYZlJ5NHdZZWtVZmRZUDQ4ZWhOVzMxV1orVFR4dExH?=
 =?utf-8?B?Q1ZDQ2FnRGZvdThPaWtNeXo5dFpHVzkxeERaY01RTGcyckI4Wm5LKzI5amgv?=
 =?utf-8?B?VjdLNFk0TUF0K01qOFYrbnNCSVFnK05wbDJnTEJpQUxBU0UyY3NIaFIxaHN6?=
 =?utf-8?B?d3BHb2RoTUEwZ2RDTmZSTkRHYXppdjdHK0s4UFhSSWE0SjFydmV2ZzFSTGdQ?=
 =?utf-8?B?b3ZoVkVGc2xYY2lnWGwzc245SnNJQ2N2Zk5IV0dDWFg5QUsvT09wbSsrV2dx?=
 =?utf-8?B?VEp4VTRaUjBFRlBnekVDUThiRnRZLytzWGlVM2RpMXZxSUJEWGp3NDFKeEs4?=
 =?utf-8?B?RjBaUmtEV0xRNzhjQzR4b3ZmekpZQjBIMCtTME9vRm4vL0F3ZU80QTlXeno5?=
 =?utf-8?B?THF1UDZjSGxvSE1aUlo4cElGenk4S1NlcWdYSmNUdmNNbXpHY0x6N0JEVDJK?=
 =?utf-8?B?d0drMjhzYTNIMVBqcHBqcW1iZnd5QUVMUE1jN0hmUUh6Z3dadko2aHpaZVZl?=
 =?utf-8?B?d3lJYUJzVGJScE05V3kxdlVKcys3NzQ0ZzJKWUFER1hJSlFrK2FCY2IrMmlY?=
 =?utf-8?B?S0U1N2ZicGFYc0ZXaWVzN1ZLSFhOVW9JekpDd21Nakp3b1E2VEdJVnpRbzNo?=
 =?utf-8?B?YkVDRmVreFZtTXpZRGY0bkVzS2ZWOUxhTjIxVjZNcUZ3UjlRZHI3dVFoM3Uv?=
 =?utf-8?B?MlpSZTBUam1lYThqcjdXbThNci9KbTBjajl4L2ZjUVZKMXhxODJnazZkWWVU?=
 =?utf-8?B?aEZuYWhXbWI5cGk2OEFRRFhrejdtc2RIWDhHWE9zSVByUkwwOHhGT2ttR3RS?=
 =?utf-8?B?NlJ2N2F4Y2ZQY0RzNFNRVU9raGNYZ3dNL2M3aHZiZ3RLSmQrZXNvU0dvdGZp?=
 =?utf-8?B?NTRKK3dMd1dTZUV1YkRRQkZndUpHNWRrdGE5Slplem9RekIvYU00S2hmN1BN?=
 =?utf-8?B?amdJbUVHaGF5Q1BCbGJBSlFCeDhLblBYQUVld0hNdG9sUnU5aWVxWEUvSDly?=
 =?utf-8?B?Wmx4VGkxUGhtT1picm9STFl1ODZEUFpROWt3NGE5YmpqdDE0T1E2anFIWFpC?=
 =?utf-8?B?MWdZVU9DUGZxK0R1bFJDN2VZMGg5bzJBaWxCN0ZDL0F5NU1QeTFaODAxU0pY?=
 =?utf-8?B?cC9xMlBWa1dwSnBGczNHbVNxYWdBTFRjWlNQQ216OWtyNUJESG1tRFdWTGU0?=
 =?utf-8?B?L3llNWRGT2l3U0ZxalJSQW5nUFRsNFdhZlNpaStiYzdwOFF3QmkwWmFqWmxB?=
 =?utf-8?B?WGZhSUt2QWhvWFNwVmI5UUROZStCbGpibWVyVVNPallhNnZBOWdXdGJ1bzJw?=
 =?utf-8?B?SkNLbFdBRis0RnY0OVBQL1RsTjVBTUdZOTB3QXZTbGhPNGRiNHQ2S1l0Rll1?=
 =?utf-8?B?R0FTOStQR01VNlh4c0o3aWcrcWIxWkc4TjliWG9YR2loOGxueFptbWlVeU9o?=
 =?utf-8?B?aGgvSjMyeFNqTTA1T0xnTSs2QzNDSHRra1JGRjdSQU5JTGtpZWVSUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa72d2b-6ce9-454d-8725-08d9b09ff6a1
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 05:45:33.6214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgnXOrVcwt9JVzxfLTdbzASYaNhKN9DDAH1ptt3G2CXZOaykUFgMBqKkD716I1W9Qgvvta6X9dfvZfUiDNGgnag/7ZaWRmxi7Uc7UTUNEutpoLDQ6jf0NXmZ++4v6aOr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3786
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


On 25-11-2021 07:19 pm, Marc Zyngier wrote:
> [+ Quentin]
> 
> Hi Ganapatro,
> 
> On Mon, 22 Nov 2021 09:58:02 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> The kvm_pgtable_stage2_init/kvm_pgtable_stage2_init_flags function
>> assume arch->mmu is same across all stage 2 mmu and initializes
>> the pgt(page table) using arch->mmu.
>> Using armc->mmu is not appropriate when nested virtualization is enabled
>> since there are multiple stage 2 mmu tables are initialized to manage
>> Guest-Hypervisor as well as Nested VM for the same vCPU.
>>
>> Add a mmu argument to kvm_pgtable_stage2_init that can be used during
>> initialization. This patch is a preparatory patch for the
>> nested virtualization series and no functional changes.
> 
> Thanks for having had a look, and for the analysis. This is obviously
> a result of a hasty conversion to the 'new' page table code, and a
> total oversight on my part.
> 
> I'm however not particularly thrilled with the approach you have taken
> though, as carrying both the kvm->arch pointer *and* the mmu pointer
> seems totally redundant (the mmu structure already has a backpointer
> to kvm->arch or its pkvm equivalent). All we need is to rework the
> initialisation for this pointer to be correct at the point of where we
> follow it first.
> 
> I've pushed out my own version of this[1]. Please have a look.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-5.16-WIP&id=21790a24d88c3ed37989533709dad3d40905f5c3
> 

Thanks for the rework and rebasing to 5.16.

I went through the patch, the gist of the patch seems to me same.
Please free feel to add,
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Looks like kvm-arm64/nv-5.16-WIP branch is broken for NV.
I tried booting Guest hypervisor using lkvm and the vcpu init from lkvm 
is failing(Fatal: Unable to initialise vcpu). Did not dig/debug more in 
to the issue yet.

Thanks,
Ganapat
