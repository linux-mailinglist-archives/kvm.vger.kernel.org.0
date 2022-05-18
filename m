Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C3952B6FB
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 12:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiERJ5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 05:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiERJ4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 05:56:53 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216D4B481;
        Wed, 18 May 2022 02:56:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0jAof5HiOlBl/mu/5zzLvmizvICAnM4tcsHAtBXrABHbxryqmDsnOgKwt1vos3M1KMZ/XG9ocq11Tc0xvWVqzAdN4qKVIuKEVIH0JdJiVylhKx3iQvQ7t1RI2ZdWqr4I+1Hfw4T/ASrnwhWAMB6YpzhwYmbQ6iDct6/UZZ9ogLY0M7g1XO4LRQPVgbeEbO3RZexMbl6dG8cLVIscBoAG5bfZRWChohQK7Myww7QRQpqtsi6TWKGYItNBcVf4TUmv7p221g3d47th/NlycJXd5qzBHsQneryf+zqDLuvRzSeU9yvxbV1larbWaCq4gmLb8WO3zKZsacPkS+xRZM07Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaVES08J3sVpC23GYBru/Kj/4tXMsN+dcud6cCuTyGg=;
 b=WYoq7Krgcx9AoOdSfn42Y7fFD2Dqy12cSB2gZGmbEQH+8TnWXPAyoWeHcFDVAky0Rlvjurn9f/yuCrigHdvfrjV8GPsoa4qKpxoOrGeqQBhJJtR+hDV1jWexIehmLHAjgNk9aV6HMDnIlggwBsdz6ataCLimL9XzAXfzWj7HBDP21ypmn+Ys1jaJemNaVyKekTOLfdmL0QPLDZltUXJlUfDQBh42Oloe0gTqCzBj9cb2vAuxkXCNRVWJTYTs2QMYvitPfMKBknlvvNQAjXcro+jCsAX8jSNBrbf7I2RmSRVCqd+UcfiIK9Lc6ZIe2p684NV2ad7kPtPQ9k8b37Rg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaVES08J3sVpC23GYBru/Kj/4tXMsN+dcud6cCuTyGg=;
 b=nXWG9czhmU8XdI6wvh/eL5fhqiVc+yU/OsY5w93qnpdEvTcne6B63IrXJvuihX32STWn8VGVaP5dMbwdKBDXs58n3aFv5dSUgWsU8cGJgxenpYOKPBlhYmMYv7lI6v4uz4OcsEe9oICrjqsf71pJQ6noqQ9od1lBL7/5Fh93zO5iAfgzsKNoizqQQwRadaebKghfZ3Ckg+ceeEZsA++c/g01nZDt0NN2eUbw4EalF3VRgOohchDiOpJJM/Disf8esfG5HUCDrQzvU8mHxa59SJj4CMcXlTP2heENJZRQGIjtFDE0RrLu1z9jtD0kDBG31T0Yf51xFMBwhCfVHfZUBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM4PR12MB5069.namprd12.prod.outlook.com (2603:10b6:5:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 09:56:50 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%6]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 09:56:50 +0000
Message-ID: <1df0a2f1-928a-034a-b5b5-1b24b09ce1d5@nvidia.com>
Date:   Wed, 18 May 2022 15:26:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 2/4] vfio/pci: Change the PF power state to D0 before
 enabling VFs
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220517100219.15146-1-abhsahu@nvidia.com>
 <20220517100219.15146-3-abhsahu@nvidia.com>
 <20220517122710.093c9c19.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220517122710.093c9c19.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::11) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67a4e646-ba13-482b-6a4b-08da38b4ba45
X-MS-TrafficTypeDiagnostic: DM4PR12MB5069:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50697C3E66B6355B3B665363CCD19@DM4PR12MB5069.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PaFSBkLjnj5S7DZ7oWVsbc5WCfSz4GPR2RmrCS1lLnpZ9TJzw675/gcPs+5MxYtC4VEANXHW24VqqnoqE4TNSguvfdTJ8lWnvBvlEKg3sM6H/l8ehzbUyl9V0SNqj4ZSWg4/47nXoI97MzM5jVpPf280kmn9aMEGPM25iziQ0N/uSo8La6l1j/fiQD5M7nfURkcB/GNKUu7TsQyan4oI7g3gE0+NJBxe6GFJPDP2uvJ5XttYaEu7JphpY/Btrum0AIFN17xYMF5VCFbImndaGdjJMeI4AkAIWPLedTixE4i/LZhNH9q4m1XAcxERZibtWJG1njxhkULKYJvl+ZBf3RVylN70PAhFNMDYzekKvfeartbFzYzggP6NqGOVyOqy4k5vDAhhlczSmP5+Tz4xHuSHfPbu96fPFuP99KzB/C0eaMqi24hedRx2xOHZl016Hs4+oqC5Lktbab1MzJW4ovsBhm8YBmjIU3XG10UE9vtBfSDGPvQdNH3YOXf3LURK8/tQl1+pIvSX5u3ZZVK3zCCfh5KWJvBUJ3nPxC44z/E1WIwB+SdR1UpuY4XdAhbKbxkdwVAxzadaJTiEmTop1cT2oJp2oZQ67kW/3i/pS9O8GnZHAMIqA4v5bJlAanbFxw0XSxOv6sUcop2jkiyOcjSLzOyKAmOK2yKYqMEGigu3NAMU4wLS9nGXu87SBk7uRoMJ5qqD+35tM2QWkEWhRLh1aBAtNs/top8LdFZCz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(5660300002)(54906003)(86362001)(31696002)(66946007)(2616005)(7416002)(186003)(4326008)(66556008)(8676002)(6512007)(66476007)(508600001)(6916009)(6486002)(6666004)(8936002)(316002)(53546011)(55236004)(36756003)(31686004)(38100700002)(2906002)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUpEWHU2c2luMmNLYXhMWDRiTXdLbytOcTM0OUw4YzFHeG1KY3o3U3E2cEhT?=
 =?utf-8?B?UnVvMXBhT2k1T2Y3YSttK21aY3J5dXJ0YW5vMkpHZjlmaUwyWFdlaG9JZ3pU?=
 =?utf-8?B?NUZaeUlFTlp5NHh5aE5YMHlRaVdJcUllaytiMHh2UXdTZDFUZ3Q3SnRNNDR6?=
 =?utf-8?B?N0svTDdRWU9ScTJuU3VjTGNkMEd2QUFYbEpWZ1NJL2VIeEFmK0xtcU9tM2lm?=
 =?utf-8?B?NXQycE5FNXFMMnBNK1R3R3huaE93VWdLcThjUlhBbEhSV2RCVkFkNWt2cnRT?=
 =?utf-8?B?QXZBenFRRXdIYzJPVjhMR2s2dzBSazBpTEtnWFlNLzdSczZReUplMDY2MjdM?=
 =?utf-8?B?OFV3K2lHdG9zblhQOEY5K1ZTTmhTa2dWZFovdUprRk5DTDVRTzg4RHVKQUx6?=
 =?utf-8?B?akx0bGxYVTRkcWVrNHg4SjRZa1l5YldqNStuZlRjckl3blhCKzI5WGNOVWRi?=
 =?utf-8?B?eXg3UTBtNml1Vmt1RXlFWnV2L3Y3ZnRib0pHTy8rNzJaQ05GWktqeGIzWDBm?=
 =?utf-8?B?eElnNmFJMzBHSGlnZjZlL2FxcE00SGkyQXFFUUNrOHJpeVJVVi9KM2lBMjdJ?=
 =?utf-8?B?ZmNGVGVtUkZsL0pWbzJiVXU3RUhENWp4aEVBcGZQR3NDRlhmQk1ZYVl0SHVJ?=
 =?utf-8?B?bUlrN1lkaVlMRXlpR1VaaWNudDVKTms0N05oNlZqRkpMdlExdEtYTHFHdnpT?=
 =?utf-8?B?TlNibXhjRkFjRUU2YU9pRXhDOThEWHFoRWc0Q0thMkJFTElUOTFCbzhNSmtH?=
 =?utf-8?B?aFI4Nmx2M2JYKzJhQ1o4ODdGUW1ta1g1WFcrRC9WUEhsQmtTZWg1SW5paGxH?=
 =?utf-8?B?NEQyaHJicmZwYytteTBmbVpwbVhudXY2VGJ2R2hrNHZzVW9pV3JFK1pGMm50?=
 =?utf-8?B?SWRhSzdUZ2RuSlFtLy9xZnlhdHVJVkhBOXc4azVSUkVxVTVrd0xSUWZjRjZ3?=
 =?utf-8?B?Ukl2alVsVzRESlFlWHE1b21NMk5nTVhyNGkzSkdvb2Q0dVRJRXZxV2FSQWkz?=
 =?utf-8?B?UDRVekVSa0oyWmZ6a0RyUUc0RGdWQktMdXRVc0hNT0hSSGYyZzliMC84TkZo?=
 =?utf-8?B?Z0ZyMkZPaTZ6VXF1MC9WMGl5UmRhV2M5aHA1NmNESFZVRWUvMXB5REhnWk9V?=
 =?utf-8?B?dkQvY0IvbTFXcS9ZMkdtWnZrdHp4T0xnTlRENUVWaXprZWlyS09RSnk3U3Yw?=
 =?utf-8?B?cWtzWFhlYVF5RnloREw5SFpHdVAxbGVMK3N5REpDRGk3TXIzMzNaRy9PemhV?=
 =?utf-8?B?SmJZZU80c2NjNUVvdXQwU1M3bHJKMVZqTVdERHJhYmgvdVNpc09pbkxGUVdk?=
 =?utf-8?B?N1JkWHREQmFIekxvZW1ZRncyTVYyaVBxdDhCVGZoSW9oNHR6bGlQTDlVVTlu?=
 =?utf-8?B?NTN0TFpKZ25jRzFZMEppaEgvLzZmWUdiVUMvQ3AxTkEzU01jUDJTVHJJUWJZ?=
 =?utf-8?B?TlNDSytzc2hidTZDNjl6QU1FTUdOWmVzZHc1amY2bVFhY0NPNEozTFNJZTc2?=
 =?utf-8?B?VDFRR3pXWWcxQ1FxQ2k0b2IyNk5KeVFvYzZLb2JZNTZUb1F0QytJOXNKZm1k?=
 =?utf-8?B?eWUzZjFwaVdkVkFxZGk1K3c4ZUFxUHJ5dk1lMWhySGVLT2xFV2V1UGpHczFz?=
 =?utf-8?B?MWtIdWpPT2FLNmY4OVlXc0VyWCtMOE5FWVpJTzlXN3VvQm54VHpCc3ZEVkFn?=
 =?utf-8?B?WDUvYlpkbis4TCtlRFJPMUd4Vzgwcm1pekU1Mkl4Y00yVGdteGg5Uk8vY21a?=
 =?utf-8?B?bUFWY0FFd21GNDVvQmNhalNDR1BWTnF5YWkrbkRjbk9wTHgrWllEVk8yTFRI?=
 =?utf-8?B?Vm5qMWk3QzVoSGgyMi9RNk1GYmY5ZVdFdnZMOUduUkJxZEI3N2ZqYkNvczVL?=
 =?utf-8?B?amdWS1JzT0VMUjk0SWFTMC9tQThHTmNvanhwK0YxUHdFME1aYm9ETTZ1NDdj?=
 =?utf-8?B?TmtXTE0vUUdqRFFqOWV6Sy9ONnU3RHE0Tk5DNFdtUFJsOWZLa3B0L3VmQUdm?=
 =?utf-8?B?WHplZVFSNnVla2hLTWNZOFc4UUt5NjBaR0thNVR0QUIxTDZ2TzRDdFpFRGVY?=
 =?utf-8?B?aWthSUNEM2Qwd0l3eGhxS2Rka1Nmd2VSclg2K00zQlVpK0lsaXpaanNzUTZT?=
 =?utf-8?B?ZUNGY1M5S2RrQm1hM3ArTm14c3dNU1R2VFAyWTFOeWtFVW40K3QzTmRjUnll?=
 =?utf-8?B?a3dRTTAxWnBJeWg0cTkyZ25HUCt0cG1QTG1OVjRQOEw0ZkVreXNjcjZUa2ZU?=
 =?utf-8?B?UGN2SFFQcndwWjZRWjFDOFhPSVRqanZtZ0xaQW03emRmUS9lUXdGRjY4LytS?=
 =?utf-8?B?VGVSYTBLNWVCdjZmcHRUdERxem0zaEJsRmZ1eHJNTlZybThLYllXdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a4e646-ba13-482b-6a4b-08da38b4ba45
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 09:56:50.0475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSIWxD/wsNAOySGmi3zPsGa3zBXIVn4KoxG8UCUVfGOUsnQ3Q7TcXstafmmLWfhL2FNCk7ghNk+L7Gk9tu4PGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5069
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/2022 11:57 PM, Alex Williamson wrote:
> On Tue, 17 May 2022 15:32:17 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> According to [PCIe v5 9.6.2] for PF Device Power Management States
>>
>>  "The PF's power management state (D-state) has global impact on its
>>   associated VFs. If a VF does not implement the Power Management
>>   Capability, then it behaves as if it is in an equivalent
>>   power state of its associated PF.
>>
>>   If a VF implements the Power Management Capability, the Device behavior
>>   is undefined if the PF is placed in a lower power state than the VF.
>>   Software should avoid this situation by placing all VFs in lower power
>>   state before lowering their associated PF's power state."
>>
>> From the vfio driver side, user can enable SR-IOV when the PF is in D3hot
>> state. If VF does not implement the Power Management Capability, then
>> the VF will be actually in D3hot state and then the VF BAR access will
>> fail. If VF implements the Power Management Capability, then VF will
>> assume that its current power state is D0 when the PF is D3hot and
>> in this case, the behavior is undefined.
>>
>> To support PF power management, we need to create power management
>> dependency between PF and its VF's. The runtime power management support
>> may help with this where power management dependencies are supported
>> through device links. But till we have such support in place, we can
>> disallow the PF to go into low power state, if PF has VF enabled.
>> There can be a case, where user first enables the VF's and then
>> disables the VF's. If there is no user of PF, then the PF can put into
>> D3hot state again. But with this patch, the PF will still be in D0
>> state after disabling VF's since detecting this case inside
>> vfio_pci_core_sriov_configure() requires access to
>> struct vfio_device::open_count along with its locks. But the subsequent
>> patches related to runtime PM will handle this case since runtime PM
>> maintains its own usage count.
>>
>> Also, vfio_pci_core_sriov_configure() can be called at any time
>> (with and without vfio pci device user), so the power state change
>> needs to be protected with the required locks.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index b9f222ca48cf..4fe9a4efc751 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -217,6 +217,10 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>  	bool needs_restore = false, needs_save = false;
>>  	int ret;
>>  
>> +	/* Prevent changing power state for PFs with VFs enabled */
>> +	if (pci_num_vf(pdev) && state > PCI_D0)
>> +		return -EBUSY;
>> +
>>  	if (vdev->needs_pm_restore) {
>>  		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
>>  			pci_save_state(pdev);
>> @@ -1960,6 +1964,13 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
>>  		}
>>  		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
>>  		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
>> +
>> +		/*
>> +		 * The PF power state should always be higher than the VF power
>> +		 * state. If PF is in the low power state, then change the
>> +		 * power state to D0 first before enabling SR-IOV.
>> +		 */
>> +		vfio_pci_lock_and_set_power_state(vdev, PCI_D0);
> 
> But we need to hold memory_lock across the next function or else
> userspace could race a write to the PM register to set D3 before
> pci_num_vf() can protect us.  Thanks,
> 
> Alex
> 

 Thanks Alex.
 Yes. We need to bring pci_enable_sriov() also to protect this race
 condition. I will update this in my next version.
 
 Regards,
 Abhishek

>>  		ret = pci_enable_sriov(pdev, nr_virtfn);
>>  		if (ret)
>>  			goto out_del;
> 

