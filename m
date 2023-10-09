Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053D07BD8FF
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 12:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346015AbjJIKwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 06:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjJIKwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 06:52:21 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE888E;
        Mon,  9 Oct 2023 03:52:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhqK6kMAB7QlK4WUNzre/YS0depJzBRkpvswKviE4GVYrsFiiTY/j+ARWgfV45iqd1qO7Do7JA9pEBYkyaIDiRttzhkg/UQjmho1jhPjbfWsVBoTaas26f3HjJku9fSWynV8+3/uOlHKDRAZwnByKDPh4I1/hnLNojiOWlYA85O8fBf3WyrZwueVJDvD67yv/3NOCKxFRygoXBfO2H3uQVFcjg/CyY1pafIzYgQwqyPdrVsDLnAdAUK0wQtTg2FZPm+FIFjz67QCDPG4Dm52hGiDVTjiO01oqplJqCV6Dq3Yq+yncovms/HgBzQgfsDWzr1XZP8uoZc8DBTNp7aQsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2AIJap9D02Bsf8hkAhNA6A9dk0BI2+3qtG77o4WtaQ=;
 b=UqClIPWkt08EmP/HEtAT+IkjkrmZURSjlbtgHhily896jXi/NMQ8VB1OyK3WuybC3NTlfaUS0+Nz3w6fkHv0oL6piqAeDm0dgSwnpMFZchbjXfcNBtvhCzatNtFyODAK8S3+vHpT8Lcy16+fTM82K5wr9HgCrf7hETnyMOU0QjPHMjuiH1HimSM49eYfDQdy5it7MPa3JCGc6xjMPRfCkSxwk/sf0eWguChRbn3lJuNzGSqcKuXjOMn5Hldmmpl6Ciy3+l+zg7rQBDGUrRsrP55C7pPAmVq6Ulo/TAwkniZRtwcOK08R5NPGSFQrR1kQb3nPUMOV7wBjXq5DvLj8dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2AIJap9D02Bsf8hkAhNA6A9dk0BI2+3qtG77o4WtaQ=;
 b=s67hKoxgtlRHmr7kW2guG4noed0vWJcnDGypdHplLHQxa3PlV+h9PCymQuYzRQ/KGrYiunH8rfAHEsEU4xp4EsKa0vQfnulJ0KTrUKabnNgCWlsgHOZr7dzydz1q6p0jPDbUf95OUvXHSgFGG8hZqfQW5h79SGLcqiLuWoNFOzs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB8657.namprd12.prod.outlook.com (2603:10b6:610:172::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 10:52:17 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 10:52:16 +0000
Message-ID: <de5450a7-1395-490c-9767-7feee43e156a@amd.com>
Date:   Mon, 9 Oct 2023 21:52:00 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
References: <cover.1695921656.git.lukas@wunner.de>
 <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:806:23::30) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB8657:EE_
X-MS-Office365-Filtering-Correlation-Id: 82ed6d59-edab-4731-c05c-08dbc8b5cd29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTbelLFFYlIVdNakAcy7sON5s9k1/NsnhijuJNvcm2deJg8eF1skyk96WLrjnGDJL4EkOi5LORbf2bNfzql2yk2e8UKS/D0AXnl0MtBRet6tNhdKEVCRGxmKAkpXxi3qDNgnsybSlMI2dc1a3scMMHERzi7DWPs5Chbmx7VQ4wwyjyjV3Va194ZDbeyggtzFxj+HVAR5LFiIlCXIfDas9KloDO8a0FJvmjuwJVKr2xgJ/YF19S9cpe+y9EiS4WzdhzaYRd95uT+ZqTnOy3Aydrr2OTYtqYkwvuOv+UZBW8Djp44rdImADnSVcX4LvN2IEiXcG9YGc0C7BywkshY87wYj0kJFveDi9yCwA0MTH2992jONpzc+CEWp4e1SwrNfH5SzwZIOByJACA+J6orfOdJWPlqmSlnHBxWWlH3KAyjS9iYqj8EmyFn+LTKfOuXfnyOYh476TRLgQ72cOvFDhguYTflPFZIGpi47Myb0ylGAwWAmUbk7C6YU/pM+CC4syPKMB3YK3PwnarJlrQHmZbDqKyzbF6c3i2l1sWdTWEYTQJQ1QXYASb3HV7HX207XTScWRBKHYlCKywNMnQwl2lLiwVHMg8pCr+clbH9tj4WlR//+gcWm5CwYcv9MV9YmEybV3r98n8KMXhe4pRpLGxIGYh3puBdkCzTghe+vFWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(366004)(376002)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(6512007)(53546011)(6506007)(2616005)(478600001)(6486002)(41300700001)(26005)(83380400001)(7416002)(2906002)(5660300002)(66476007)(110136005)(66556008)(54906003)(66946007)(4326008)(8676002)(316002)(8936002)(38100700002)(921005)(36756003)(31696002)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0RsenkvU0JWQVJMM0EycVJxUytQYnJXTVAvZ0JHdktYTU1mMGxMdVNUZXlM?=
 =?utf-8?B?VEVjRzlxamdaVS9HeW5IOGFVVGpWSXpKbVR3K2J3a0lLVnhIOUlldklocCti?=
 =?utf-8?B?QytLdkppVTZhVHE3Y0lOZmFNc1hrZiszUHJ2TFZKZHNnUUlwQ21jM1dsQjhQ?=
 =?utf-8?B?T3ViVjNEL0JGaTAvREtwMGZ3Q2NlUnM5S2F3bWQzZW5sblpodHZrUWNLaEJW?=
 =?utf-8?B?R0U1UHVBL0tid1NRSkd4MVJaQmduNmw3V2hCR3MxMDBjMDhoa09KYUF0TUNt?=
 =?utf-8?B?MEZLNzgwQ3ZpQzZzOXB6MVUvZ2xuQ2FTOGZqdUpmMnVYajFQd29HLzcyejlx?=
 =?utf-8?B?Wjh5blVqdEpjZG5rbklsOFJaVzBDZzJ2WVhyY3JOYTd2Ull1cUpJcDU4Unlp?=
 =?utf-8?B?RE1jVGhhWUN6SWtubGlOTDdodEFveUY3aHJlRTBQcmVLbjVlRUVZbGFYVm5v?=
 =?utf-8?B?S2czbFVqeldTM2xqMHYzemdlOWZPSXZ6Y2VlVVkzTGhURXcwNmY4RHgrRjhK?=
 =?utf-8?B?VHN5bW1NWlJCRmxZKzBQdE9hTkVlcWl1TTlPa2p4QWt5azVLUUovMSs5WGVr?=
 =?utf-8?B?Y1c4YWhVNDV4ZjJ3Vy83S0RFOUY1czEra2VCOGJlZmFjMG5vSDBaNiswbEtD?=
 =?utf-8?B?Zkxob1JtbkVUY0c0MzNYcFJSaFpydkFvTUdhZVJ3MVVrVmZXN21hWTNZanNp?=
 =?utf-8?B?ajJJRld5Rit4L0dIMTM0b1lQVEZEYXd0TWpMSGJ2ZFRvdkNkUUhTOUs3eWFp?=
 =?utf-8?B?eXdYM09jczBHRzd4YWc3L1VrTVBzSVZMWERGVndmM2JBZlpFSmY3SndkTURm?=
 =?utf-8?B?MGVEVVo3QTNpbFFmSzRBS0cvanFrek93a1h4Rng0VFlUdWc1UWdJVjVaTkdU?=
 =?utf-8?B?YnNyWUNER1cxYUg2YklRRitSQk8yeHQwU21aSXFNb0JuRG1uM2FBTS9idkFQ?=
 =?utf-8?B?cFJhbDFNSEd3am5ER0dWblovZFMrcVJLR05rZ2liakk0SGZaSEhkcEQ5cDZD?=
 =?utf-8?B?cFh0RFNSTkFqakJzeEpTVE9OdkRSRC93akFvUGR0RWtiZ1RxK2ZRSUNQeHk3?=
 =?utf-8?B?YmwzSFdGdFRTczROV0dFRUs0bjBZblBqcDVxM0dWSlRpSTBWd3Z2T3pDTE5H?=
 =?utf-8?B?bXZ6N0pmNWhZMjRCY0xVeGVZWkxiRWh4NzZVL0lRelVNSHh1WjZxR1RrZXVt?=
 =?utf-8?B?RWUwbm9lREhvcGpuMTlRYjNMQ3NsOUp1NUM2Z0NOM2dLL0h5Znk1cGJTd0VU?=
 =?utf-8?B?ek9GdnEycWx1Q3UxMGdtdUVrdVlCWGFWTUhSYXlzQjhQRTBhdE5aWkRSTEYy?=
 =?utf-8?B?MWtmQWpWeGJubHpNMngrb2Flb2xna0hScTB2cFRkR3FlbytGcllPOTFxc2Er?=
 =?utf-8?B?TXZwRDNGaGxqVTZ6UXNxeE9kVHNUK2ljSzZSZDUyZldQZFBRS1RPcUxtb3hX?=
 =?utf-8?B?d3JvdWJVa01rUFRrSHNkVmRQd3NIMnZiUnFjWmRicDVIOTRYQmJXUkdxazNZ?=
 =?utf-8?B?YmZiS0JTOWVIM0RUUERaZU9vOEdkMnZqTXZoVG5PdHQvNng1blEwQWdlQ0h5?=
 =?utf-8?B?V0ZCWkpOdFdRMGJnUDk3c2REMkxNRCt6V3RmQWw5S3UzRHdoTkZQemFndVpx?=
 =?utf-8?B?WE1lbS95cTlMTmZkaDJzRzR0M1FzcGFsQTBVZllhaUQ2b01WVFd1TmU3cmFk?=
 =?utf-8?B?UzMxTnk5enFNdFpvSHdIdXduNktFZnlxSnZyY0ZWZUxNWVFheUpmQkszL1Nw?=
 =?utf-8?B?djlvZWtWaFowODVCc29aMDZDVVd5a3crNzljeld3YjZXSUVCdlFIUCsxL2k0?=
 =?utf-8?B?U3R4cTFaVjJrZVBXbGdOSDZWc1Z6T3hka1VsRkY5WXp0cU5uWFpyNzZRcXFS?=
 =?utf-8?B?K1g4b2RWdUpsSFQyQ05ObWlDN3djL2FmYmYrazV5TElhaTlXME1tTzdUV05K?=
 =?utf-8?B?bE9mSS95OExPa0lMYTB5V0ZyMmpDYW95cG5vZDNQM0xENFZJVDV2RXJDZTV2?=
 =?utf-8?B?QVYxeTNLMXlyVEtnb0VVYVVHbktubjlVeWhpZWpIck9NSmxSU0lreHVjZXpn?=
 =?utf-8?B?ZWdUQ0l4VzV1TUp3MjNTZGFRV0hyQzBvbTVlcGJrbmNUeGhuaXlJQmlFR0pp?=
 =?utf-8?Q?m4FHCs3zFTLTx913/YRXMS8ik?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ed6d59-edab-4731-c05c-08dbc8b5cd29
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 10:52:16.2404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKu6+DcgOPU2Voe+OE/wR0nMWDvKkiAjcowuEUiIBxKn7NMluG3yA2eTyV+//XVjGkD2zitY0MD9gfWXutF0sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8657
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 29/9/23 03:32, Lukas Wunner wrote:
> At any given time, only a single entity in a physical system may have
> an SPDM connection to a device.  That's because the GET_VERSION request
> (which begins an authentication sequence) resets "the connection and all
> context associated with that connection" (SPDM 1.3.0 margin no 158).
> 
> Thus, when a device is passed through to a guest and the guest has
> authenticated it, a subsequent authentication by the host would reset
> the device's CMA-SPDM session behind the guest's back.
> 
> Prevent by letting the guest claim exclusive CMA ownership of the device
> during passthrough.  Refuse CMA reauthentication on the host as long.
> After passthrough has concluded, reauthenticate the device on the host.
> 
> Store the flag indicating guest ownership in struct pci_dev's priv_flags
> to avoid the concurrency issues observed by commit 44bda4b7d26e ("PCI:
> Fix is_added/is_busmaster race condition").
> 
> Side note:  The Data Object Exchange r1.1 ECN (published Oct 11 2022)
> retrofits DOE with Connection IDs.  In theory these allow simultaneous
> CMA-SPDM connections by multiple entities to the same device.  But the
> first hardware generation capable of CMA-SPDM only supports DOE r1.0.
> The specification also neglects to reserve unique Connection IDs for
> hosts and guests, which further limits its usefulness.
> 
> In general, forcing the transport to compensate for SPDM's lack of a
> connection identifier feels like a questionable layering violation.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> ---
>   drivers/pci/cma.c                | 41 ++++++++++++++++++++++++++++++++
>   drivers/pci/pci.h                |  1 +
>   drivers/vfio/pci/vfio_pci_core.c |  9 +++++--
>   include/linux/pci.h              |  8 +++++++
>   include/linux/spdm.h             |  2 ++
>   lib/spdm_requester.c             | 11 +++++++++
>   6 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
> index c539ad85a28f..b3eee137ffe2 100644
> --- a/drivers/pci/cma.c
> +++ b/drivers/pci/cma.c
> @@ -82,9 +82,50 @@ int pci_cma_reauthenticate(struct pci_dev *pdev)
>   	if (!pdev->cma_capable)
>   		return -ENOTTY;
>   
> +	if (test_bit(PCI_CMA_OWNED_BY_GUEST, &pdev->priv_flags))
> +		return -EPERM;
> +
>   	return spdm_authenticate(pdev->spdm_state);
>   }
>   
> +#if IS_ENABLED(CONFIG_VFIO_PCI_CORE)
> +/**
> + * pci_cma_claim_ownership() - Claim exclusive CMA-SPDM control for guest VM
> + * @pdev: PCI device
> + *
> + * Claim exclusive CMA-SPDM control for a guest virtual machine before
> + * passthrough of @pdev.  The host refrains from performing CMA-SPDM
> + * authentication of the device until passthrough has concluded.
> + *
> + * Necessary because the GET_VERSION request resets the SPDM connection
> + * and DOE r1.0 allows only a single SPDM connection for the entire system.
> + * So the host could reset the guest's SPDM connection behind the guest's back.
> + */
> +void pci_cma_claim_ownership(struct pci_dev *pdev)
> +{
> +	set_bit(PCI_CMA_OWNED_BY_GUEST, &pdev->priv_flags);
> +
> +	if (pdev->cma_capable)
> +		spdm_await(pdev->spdm_state);
> +}
> +EXPORT_SYMBOL(pci_cma_claim_ownership);
> +
> +/**
> + * pci_cma_return_ownership() - Relinquish CMA-SPDM control to the host
> + * @pdev: PCI device
> + *
> + * Relinquish CMA-SPDM control to the host after passthrough of @pdev to a
> + * guest virtual machine has concluded.
> + */
> +void pci_cma_return_ownership(struct pci_dev *pdev)
> +{
> +	clear_bit(PCI_CMA_OWNED_BY_GUEST, &pdev->priv_flags);
> +
> +	pci_cma_reauthenticate(pdev);
> +}
> +EXPORT_SYMBOL(pci_cma_return_ownership);
> +#endif
> +
>   void pci_cma_destroy(struct pci_dev *pdev)
>   {
>   	if (pdev->spdm_state)
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d80cc06be0cc..05ae6359b152 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -388,6 +388,7 @@ static inline bool pci_dev_is_disconnected(const struct pci_dev *dev)
>   #define PCI_DEV_ADDED 0
>   #define PCI_DPC_RECOVERED 1
>   #define PCI_DPC_RECOVERING 2
> +#define PCI_CMA_OWNED_BY_GUEST 3


In AMD SEV TIO, the PSP firmware creates an SPDM connection. What is the 
expected way of managing such ownership, a new priv_flags bit + api for it?


>   
>   static inline void pci_dev_assign_added(struct pci_dev *dev, bool added)
>   {
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1929103ee59a..6f300664a342 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -487,10 +487,12 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>   	if (ret)
>   		goto out_power;
>   
> +	pci_cma_claim_ownership(pdev);


and this one too - in our design the SPDM session ownership stays in the 
PSP firmware. I understand that you are implementing a different thing 
but this patch triggers SPDM setup and expects it to not disappear (for 
example, in reset) so the PSP's SPDM needs to synchronize with this, 
clear pdev->cma_capable, or a new flag, or add a blocking list to the 
CMA driver. Thanks,


> +
>   	/* If reset fails because of the device lock, fail this path entirely */
>   	ret = pci_try_reset_function(pdev);
>   	if (ret == -EAGAIN)
> -		goto out_disable_device;
> +		goto out_cma_return;
>   
>   	vdev->reset_works = !ret;
>   	pci_save_state(pdev);
> @@ -549,7 +551,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>   out_free_state:
>   	kfree(vdev->pci_saved_state);
>   	vdev->pci_saved_state = NULL;
> -out_disable_device:
> +out_cma_return:
> +	pci_cma_return_ownership(pdev);
>   	pci_disable_device(pdev);
>   out_power:
>   	if (!disable_idle_d3)
> @@ -678,6 +681,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>   
>   	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
>   
> +	pci_cma_return_ownership(pdev);
> +
>   	/* Put the pm-runtime usage counter acquired during enable */
>   	if (!disable_idle_d3)
>   		pm_runtime_put(&pdev->dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2c5fde81bb85..c14ea0e74fc4 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2386,6 +2386,14 @@ static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int res
>   static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
>   #endif
>   
> +#ifdef CONFIG_PCI_CMA
> +void pci_cma_claim_ownership(struct pci_dev *pdev);
> +void pci_cma_return_ownership(struct pci_dev *pdev);
> +#else
> +static inline void pci_cma_claim_ownership(struct pci_dev *pdev) { }
> +static inline void pci_cma_return_ownership(struct pci_dev *pdev) { }
> +#endif
> +
>   #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
>   void pci_hp_create_module_link(struct pci_slot *pci_slot);
>   void pci_hp_remove_module_link(struct pci_slot *pci_slot);
> diff --git a/include/linux/spdm.h b/include/linux/spdm.h
> index 69a83bc2eb41..d796127fbe9a 100644
> --- a/include/linux/spdm.h
> +++ b/include/linux/spdm.h
> @@ -34,6 +34,8 @@ int spdm_authenticate(struct spdm_state *spdm_state);
>   
>   bool spdm_authenticated(struct spdm_state *spdm_state);
>   
> +void spdm_await(struct spdm_state *spdm_state);
> +
>   void spdm_destroy(struct spdm_state *spdm_state);
>   
>   #endif
> diff --git a/lib/spdm_requester.c b/lib/spdm_requester.c
> index b2af2074ba6f..99424d6aebf5 100644
> --- a/lib/spdm_requester.c
> +++ b/lib/spdm_requester.c
> @@ -1483,6 +1483,17 @@ struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
>   }
>   EXPORT_SYMBOL_GPL(spdm_create);
>   
> +/**
> + * spdm_await() - Wait for ongoing spdm_authenticate() to finish
> + *
> + * @spdm_state: SPDM session state
> + */
> +void spdm_await(struct spdm_state *spdm_state)
> +{
> +	mutex_lock(&spdm_state->lock);
> +	mutex_unlock(&spdm_state->lock);
> +}
> +
>   /**
>    * spdm_destroy() - Destroy SPDM session
>    *

-- 
Alexey


