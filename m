Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AA73C9C14
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 11:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbhGOJri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 05:47:38 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:46221 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbhGOJri (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 05:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1626342283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9pgcUlEz74IZTdHdaUXk5JLYSOmI68SSuZr5ztBIPI=;
        b=DeYVsOGjZst+Z7zLUpSP6QzYz7ecwPdp8prELneklHrw6cCel317Wzoe0x7APCCLCoVQoN
        FKY86mjdnLohk+0ES34lGRMiAtLml8xDu+z7uu6fYSSJ9yeE2zh8hHhq5cjs04AKx+Q9TI
        mWaInd/S3LEdXtb70Ol/pR78rcFRK3I=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2059.outbound.protection.outlook.com [104.47.4.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-6CvbyWXlOu2E9xYOXVRhgw-1; Thu, 15 Jul 2021 11:44:42 +0200
X-MC-Unique: 6CvbyWXlOu2E9xYOXVRhgw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htlT7jwk9sOSow4aUXIFpbZwc13B+BsQRfrwnUtnyW9cmQRJeMsX9AH3KYFlDG2JOalhtR3tIZbYxhkFbChA3GgW/cA05iVSBe0ybZBvsr6/X1alSXsDIpa1jZBHkbQp23EXz5Pa7V6Mg5PcH+oFKKKGEMd87BboWMNl+tzfrwDcWkt9M27wjqeSr68+EJLJJ5ib2rEVOaMZzCgbw72CwwRyeu5y5ZbBDFbwVDXZOjXzBt/V6ho72xRHscj5EB0t5mKqAOLn4oXzDrpDoYhbSwSB6yItHHrZuvKAMQMHJv7mboMS6zafyA/zXEGaKnD3+BqFJs3wyKMg3nLT0V6oXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TX6RsXvp0ZJt2BckOx6Z2HNd6qG46qG8BpY4QoW8Kak=;
 b=I2ciWx+CCbzSPaQ/EV/i1F4tEITcEaGNR/niHGnUMrDcS4r1KyGUhPtTY89YsZMvYFTIXzB7zWRY1k7mWBMo2laCTlTpER389pPpEqK6OTRIsvbjVnPjImXSZvXuN6ATzqy/wEJvRq7zGPpXJbYs4hdtxeWfRzgstyRZvEi6ePyz56RF9aphHQcunKBMplvlnpowuL+P+E6MD98jQBZPhg7QnMdBCME37lSIlAmoItmoMPcE5QrsQx7qjj9ADpBQART9pSSxhbQ5Zkj1kgNoi9qUBXRteSLy6hWv0oOJbHgMSUpjfriGL+uYijg+Nun6L/7EsdrzcWkkNSKKWrPQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
 by AM7PR04MB7015.eurprd04.prod.outlook.com (2603:10a6:20b:117::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 09:44:41 +0000
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65]) by AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65%3]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 09:44:41 +0000
To:     Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
 <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
From:   Qu Wenruo <wqu@suse.com>
Subject: Re: Any way to disable KVM VHE extension?
Message-ID: <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
Date:   Thu, 15 Jul 2021 17:44:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To AM7PR04MB6821.eurprd04.prod.outlook.com
 (2603:10a6:20b:105::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR06CA0041.namprd06.prod.outlook.com (2603:10b6:a03:14b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 09:44:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b7e425-02d0-4e6a-2339-08d947752b5c
X-MS-TrafficTypeDiagnostic: AM7PR04MB7015:
X-Microsoft-Antispam-PRVS: <AM7PR04MB7015786BB634ED40119A45E2D6129@AM7PR04MB7015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbpu1eXgjYQrhtNxQ/BLFN0K8/YSW3WE3szMFjTAZ0YWQoE+N/vEbsiYzkqte0h4PefRjtfa5+zUb4tGL1rJDge6TttNHxeF1yrt9vxDh2ZVf8uxY+fXlhuWwExMCK/HNQiM6XNQ6dt4yV5UGoo5QPml0Z2xPXGb1cQtsxi80oZv0jbvE1Ij16fJSPAqQLyPkDIEyg0XdkzCW0Hma773ZxE5TnWwSMezDLTWCLUCG68+468kFlX5RnF+n113+1kPNNVIbJZ060ollFvAqnko2b5k3lCukKWGgkgSRctZWEX4RJPLjj58dsUGaKcQh5WHiTNVJ8eh1C5Vos2ii4WyJwGTJGFId3AzI98BzuClQiYDfNrIrmplLz67lPxZ8f+xLqdHGEtccY1lapYkQ58qeuisl9dadFNyJEI5iUTdfKllK1bJjJrRKr2w/RdfjW4vWYw/qVYerKIU09kqqHUUtUru1gQ5ZXIT8mW2+QnlFBshmmUCgD0MaUefBzdsO/ZCdIMuqAjS1oByUQ7O4EgRLgmO1o+SKXSb5Ieq7b/3muLkGrRZxac94g+7bXHoiXaJru/m/CTgFfjRy1TbWVv6TMottqE/0hcYJzEOjsXS2ZvygYWMwu5rDU793S2Bz9hM+E0qCBJW9RZFHnHUligZCba+fSxbV8Lgwo0csDvQqomMkXSOzWcEcLNYs1OesZAV7REhpKoR143pGUVLLayFDn7ubjrGayX2XOQzTXRaGqgumfEnhrPR/daCs7K5z8iwUod7VNy+yrll5DC+8eICVNKdp2KG14AsccVRc4YdXz5S9jyQw7OqrlgYw+GHmkR0UvB4nM7IBVJDdS3lHWVLsw3/taFZ/Mmp2osZO9zZ8M0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6821.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(366004)(136003)(5660300002)(31696002)(2906002)(186003)(66946007)(956004)(66476007)(8676002)(31686004)(6486002)(316002)(26005)(66556008)(36756003)(86362001)(83380400001)(2616005)(16576012)(6706004)(6666004)(966005)(478600001)(110136005)(38100700002)(53546011)(8936002)(43043002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nMksWXwhbmGJiOhco/oRiFpgZq3IP79i9YZDkwmz2rj2Yk8Jj6l00kuwWU7B?=
 =?us-ascii?Q?xdwYbuG4Un5XYwQbl50KFnIqvuLc9zA/EnFSgphizXMI5BbvWNBhJYxj0ud5?=
 =?us-ascii?Q?PEX/bIHsRsQynsIVWeJNjANhKVOpb9jUZj+KJtNw8Y/aEu0C+vyN19UqiZPO?=
 =?us-ascii?Q?ph3cblaANdMFLbJOgS10fHVJi57cdxswBfW+/xC/Xu10CIEXNiCwb5eeT2tr?=
 =?us-ascii?Q?N9BlnBplXr3WdRn85wvGhbS9mmCJQ+CCa92BaiXeFijBsKivv8iQvbOM93VE?=
 =?us-ascii?Q?q9OUm0Bzwgsq+bNs8eSbgN4wGkgghjUnzcly8r56w2wCrks7s8hfAAVG4Wf9?=
 =?us-ascii?Q?JMo9Y74jrxJBACVeqp7jhQ5b3k6twlZkHVROCM0shXNRq4hzgfV+AhfnMh92?=
 =?us-ascii?Q?a/+y7jh4mv0bYOms5Dtwl2OEa/zox2q0PnjOQ2qIbxlTJU0Drjpv/PsgJcNg?=
 =?us-ascii?Q?OwFAesAvXiVldhSuVcS+5VrAls4evvmeX59ZVmtFHd0K4bd0cdyhmRM6GEmO?=
 =?us-ascii?Q?byhSqEf/Tn8WSkO96xoOSOvNov+9BZ01GX8CYFQ/Jf8XXsD1UkKA+7bzm3P8?=
 =?us-ascii?Q?eCjLkaNY1HVkrY62tB7JeaoL9i0jhU434Mu5M37M25TyWyIn2RD3eE50GBiF?=
 =?us-ascii?Q?6ZsNVYvDQunrQEJAlPmlTSVco7jg4Fkeii7ivWHvxYhumQW6crwVbkBXF6Tf?=
 =?us-ascii?Q?m8l2CFNxqI21pBjPIkTJS9X1zLQY177IV+Ov5T1xCwMsvUvkk5ViJHdccpyw?=
 =?us-ascii?Q?KNkU6wAmEUAmwAhgkpyGs94HyuhNVvQ5Ho1xlD55+9vPYB6hpDzdV97oxElc?=
 =?us-ascii?Q?vw139mdKCnBQUUYVm9CeDXxGI8lMlTieswuKna/ORxTNZ4sS4wg7pXgXeexg?=
 =?us-ascii?Q?vuvZynpTTJFmALwC7HRkNfMshAWy51Smwn7OzHopcum+PvMvg59Ov4UQpGSm?=
 =?us-ascii?Q?p0TObnM3NN4BDm2SMvrRst1cZyD1J3c/elELi8g8lW97Vcw3bTvGTqRCBgk6?=
 =?us-ascii?Q?Inaij0vctq7850Jq1GnxGXvccKfytPfw+RwDtiJSTidHsHJgs9+01v0Wm3Zs?=
 =?us-ascii?Q?l4vQJxUtEUUXT1wz2Whr86XOfoqciQkRGz9E+DHJXZIVOUQhmLY95L0H+W33?=
 =?us-ascii?Q?Sz62PAuRFVUaSyuy6Ryv5wVBC2+aucCjAEJpbOrsnLZBkqcUbHCb4TRIZl+J?=
 =?us-ascii?Q?Uxr6yAxjo+LjsbGndWAeOdDnTGX/Hx6wSoxEeFuGiSlZusOF9xDeWGkbVkzJ?=
 =?us-ascii?Q?9P6MBw7EOHTsntMti0ANb8PQcNaX1SefTyQGYK4cxcpOJl900ZaHvgprw+/+?=
 =?us-ascii?Q?Sdb5rE+g21biTbsSW0ARCV7U?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b7e425-02d0-4e6a-2339-08d947752b5c
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6821.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 09:44:41.4776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aai4LowXJ7KykwdhDhFhWULUOr1SH5cMmF35viPVZ+nggw4lMO9UO6a7CI06axa3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7015
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/7/15 =E4=B8=8B=E5=8D=885:28, Robin Murphy wrote:
> On 2021-07-15 09:55, Qu Wenruo wrote:
>> Hi,
>>
>> Recently I'm playing around the Nvidia Xavier AGX board, which has VHE=20
>> extension support.
>>
>> In theory, considering the CPU and memory, it should be pretty=20
>> powerful compared to boards like RPI CM4.
>>
>> But to my surprise, KVM runs pretty poor on Xavier.
>>
>> Just booting the edk2 firmware could take over 10s, and 20s to fully=20
>> boot the kernel.
>> Even my VM on RPI CM4 has way faster boot time, even just running on=20
>> PCIE2.0 x1 lane NVME, and just 4 2.1Ghz A72 core.
>>
>> This is definitely out of my expectation, I double checked to be sure=20
>> that it's running in KVM mode.
>>
>> But further digging shows that, since Xavier AGX CPU supports VHE, kvm=20
>> is running in VHE mode other than HYP mode on CM4.
>>
>> Is there anyway to manually disable VHE mode to test the more common=20
>> HYP mode on Xavier?
>=20
> According to kernel-parameters.txt, "kvm-arm.mode=3Dnvhe" (or its=20
> low-level equivalent "id_aa64mmfr1.vh=3D0") on the command line should do=
=20
> that.

Thanks for this one, I stupidly only searched modinfo of kvm, and didn't=20
even bother to search arch/arm64/kvm...

>=20
> However I'd imagine the discrepancy is likely to be something more=20
> fundamental to the wildly different microarchitectures. There's=20
> certainly no harm in giving non-VHE a go for comparison, but I wouldn't=20
> be surprised if it turns out even slower...

You're totally right, with nvhe mode, it's still the same slow speed.

BTW, what did you mean by the "wildly different microarch"?
Is ARMv8.2 arch that different from ARMv8 of RPI4?

And any extra methods I could try to explore the reason of the slowness?

At least RPI CM4 is beyond my expectation and is working pretty fine.

Thanks,
Qu

>=20
> Robin.
>=20
>> BTW, this is the dmesg related to KVM on Xavier, running v5.13=20
>> upstream kernel, with 64K page size:
>> [=C2=A0=C2=A0=C2=A0 0.852357] kvm [1]: IPA Size Limit: 40 bits
>> [=C2=A0=C2=A0=C2=A0 0.857378] kvm [1]: vgic interrupt IRQ9
>> [=C2=A0=C2=A0=C2=A0 0.862122] kvm: pmu event creation failed -2
>> [=C2=A0=C2=A0=C2=A0 0.866734] kvm [1]: VHE mode initialized successfully
>>
>> While on CM4, the host runs v5.12.10 upstream kernel (with downstream=20
>> dtb), with 4K page size:
>> [=C2=A0=C2=A0=C2=A0 1.276818] kvm [1]: IPA Size Limit: 44 bits
>> [=C2=A0=C2=A0=C2=A0 1.278425] kvm [1]: vgic interrupt IRQ9
>> [=C2=A0=C2=A0=C2=A0 1.278620] kvm [1]: Hyp mode initialized successfully
>>
>> Could it be the PAGE size causing problem?
>>
>> Thanks,
>> Qu
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>=20

