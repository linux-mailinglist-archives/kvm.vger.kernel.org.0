Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BCF539063
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 14:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344105AbiEaMOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 08:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiEaMO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 08:14:28 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB60986EB;
        Tue, 31 May 2022 05:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya9/DVqeewT/cSqSk08kRBqp00S7E8zMpBSWQI40/HBgZLOmCU0wjV3UNjhL5OufedmjulGeOWtX+dT/uWW8BhxkDfKYhAN81QJetpccK4r6+frrCqnBL0r3vgVGgt2DObb267gVugRBdlArL+Ww7e896dAQQfS93G8gtrI7OKwhfEEkbZ4Yum6XuLwjjDrW5era3njnQlBPkJsOMgk5DfGqRpmY+qa1Cejs8pjb6Q12PwYs6Gq38QSiioVRRXpTiwL/hrjHS+KF2EiWdse6iBlmZ/0+7ztQ39u2+RIh4DlX9JXWeIKSV1vmRAh57bMqspT/dHj23R26eL+kOjh92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlWaG+n2ocJe9g5um+6DjnLMnUKEBajrxod8iliTn4o=;
 b=T63cvpxtPMjEyADeTPt3UsHjIMCqk5Cy7lyQeCpLH4dRpff1Z9Qp3XZb2nI142cMF1vavHsY9xsJ4blFV9SPlaoH7rRqxuMaztklllV5y/BcrmCaAnoiroW1FMr6UtVHaLuQD5OEYXekyWNzPRD90GwcZCAgO8O7pkc9uggpke+lLphuSCl36XjbTTrW7DE7JWd09eQUJYWHW1T7OoSEXrtxYJKPh/nsM3+Zm8ukvl/ZhZWTRsnk1tnxz6C6vW/fv5XxFFQUlnokn/PHtdSwCAazZFt6YfnNnz8OSFFU8bvCJfQoHszEnAZ7b1B8L0SZyeCaYUWAva4MdMc1BVOntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlWaG+n2ocJe9g5um+6DjnLMnUKEBajrxod8iliTn4o=;
 b=Hmdjq44C502j88zC08D8NTG7AVENCjWvKBoMkUifA7Fjv9Ygn+Cgz6AQXOyaDwNWTOBOzc5jwIPbhbd1a0zvR4vCTwI/Kw5z51TgBqQ8xCQLUGRmXezglH+b/xzoLMDfYKycDYMHQ+5o8c8zTNDpYplrRbqRX1n7MQnO/tjPwN4DZozEvf5WtyNTcdDZuMb2gRzeLGVQZTXm5tQIL9B4WbzwkI9UK5LUhpqFhc/V1nW0aI+9b/BQnR82oIRSFSI8Jynby0kjY1tIqVRbFU3k50g22wPGo67xSEGcxONl5jLr90r784X/YlsdqRO422k/2T3aIIxYetqtrqKzOc4SoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MN0PR12MB6174.namprd12.prod.outlook.com (2603:10b6:208:3c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 12:14:25 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057%4]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 12:14:25 +0000
Message-ID: <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
Date:   Tue, 31 May 2022 17:44:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
 <20220530122546.GZ1343366@nvidia.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220530122546.GZ1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::20) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e89bb19-9c02-44f7-4d32-08da42ff196b
X-MS-TrafficTypeDiagnostic: MN0PR12MB6174:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB6174C730B4915D1065E09614CCDC9@MN0PR12MB6174.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6BPzinjwu/swHNXth12ZqV8PyB5YPPGZgnyu6be6qRgvKLY6rgMveInQpKSnHX7kz5K/OWqZarnvqX0OUbsQ3Y7CVOFTuulwbBngJjr5wnVjDL3NjaNj9d3AROr+y9KzsrMmMeYnFHmfEiLm4stNxPTbE2sczzm/PizwoRbvU50LRqSj09YyudvtDVfoY36cd0jdFEgydBBiVzqB5O+4QCy0vQ7SFm45yyFf2OpcJ1JRQ2dOs7LSS6SYP5iwFDEfQ690Xfv5FUpWbNssmURTaODf6gsZusJpQZF9ZdCnfeLSlk5Y+gfEurQyrhip7AH69aWKzqe2aks+TyaFQtMkJpYTe6YvxYZTUx/CHFZvJnNELn7Q/uIWQIR6jEBy+npe/8vTTppg4us7+Cap5wpK2Wym8TUvsvOB8R82jdEEPxTSMSnECKlOWzBUE2GWrbNl8dZUUHk8VmjJueTMBMHQA4dJlxnU6dM7Lql0/myvd/8RTgrgJLJclRLtpjQylulYBN3n8hw6SopDb1EjJZ+KxvwA4YjoD1Ytbqs7YKd/McvcpkHL9+gbPS4EG+jPKQDqA1nWvolRoV57NPz9eAsGHtx/VEriulBzyPo/7s2Lx376qtiRZze7gWWGlTqft6WmGcidsed6rRXUtWW9ZwxKVLU0KNF2Ar6ZqbfSIb5nJVNg8prT42ChIQY6FjGqpFm83O+nfKwW26ktPqIU57OqVvK7HWSfmEu2k8t3fcpGphb2AZaI6raWFIDSlvULRzwsBIXWLMJM/i0MHwN0wKqqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(2616005)(5660300002)(55236004)(6862004)(2906002)(4326008)(86362001)(31696002)(8676002)(66946007)(186003)(36756003)(7416002)(6666004)(31686004)(53546011)(6506007)(6512007)(83380400001)(26005)(508600001)(8936002)(6486002)(316002)(38100700002)(54906003)(6636002)(37006003)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzRDeVlOTWtxQnpKVHRnTkkyTDJObWNEd1h2TTdrU0srVUhsbkhrckoySFBk?=
 =?utf-8?B?YjQybVZFbVJXWVBPZ2xOd29UMW9WUUNOMkIzWkpoZEt6ZS92aU5wdnNPRm1n?=
 =?utf-8?B?ekVHZTNqYnNlZTdRUTJzdlVkc05IdVEzU0ZvZGNIOVBrMjZZSWVPVWVYb0RB?=
 =?utf-8?B?MFpRbm9WNEhtVnNkR0xpQm10eEVCSlI5RVJSVlF6MlFsMU1ySEVUTXBnL2ta?=
 =?utf-8?B?TUl5cU9QdTFROGVaZDZNTThhWlNUQisyYjNlTC96bjloMzVTZGY4ZkhWYXBB?=
 =?utf-8?B?NEg0TVR6MDluMW5aSUgzSjhuakVBRmhmZnpHejROUytqYW9Mc2x5bmtmVWdv?=
 =?utf-8?B?Zmtyb2dyWDJETk5HWTNFSlIvTERFZmE3NE56RkswejQ0L1VBb2IxcWpENGdn?=
 =?utf-8?B?NGtVSWRoTUFVR2xFWEptQStkc282dW1semdxV1E5cG82bEVDYnREcGh5Tnhy?=
 =?utf-8?B?MzUwalVIWFExaFZFNUE2eUVCeTJLNVlRQzBPd3poMWxkeXlBcGNwZXlaWVhk?=
 =?utf-8?B?VHp4b0huTHB2YTJTc3ptUnpsVUlORmsyOXhLZWp0Vzh1OUJVUkZVNk5LVnVI?=
 =?utf-8?B?dCtSMVIrR09EbmgweDNzVTkxb3pVOC9tb0wzeUkxanBRMzY3MDNRbHdsM1Rk?=
 =?utf-8?B?ZXlkMTNGQkV5cytGWnpRQ2pqVU5ONE1LUi9IUG9uVkcyNnNDenBjbHloRTV1?=
 =?utf-8?B?RnN2aTYrVFFYNVZxZkEwTm45Sy9PNGJqNkJGWndnUllCcG1reVNKQ01USE1h?=
 =?utf-8?B?eTVrSERFS2NkVGdldGEra1RJU1EwWVpkNlprU3F5VjJNdXVlbGdyV2JibXJj?=
 =?utf-8?B?eis0SVQwbnNnVm0wU1IwQmhzSlBLOFY4WWlCRDNQdzZBYW81TGt2akUxTmxP?=
 =?utf-8?B?VVdQaEpuNWQ0S2FwcHJYbEpwOE55MkxMVFZ4cm54a1NzOVpBemlqaHpjQUxP?=
 =?utf-8?B?cnRmc2lVU3dyazZxUnQ2VlpyWVQvU0dBNGhkL09BS0MxZzlHTE5ZUUgyZU1n?=
 =?utf-8?B?ZWFCb2liRlIrSm9NR2h5M0kyMUs0OTBQWTA1N2FtS0xIcHl6UGFvSWk3VTUw?=
 =?utf-8?B?MHpsa08vWjBvb2IvemtoOEtaa0s5OVdKMFJaSC9UZXlQdlRLT1dsRGl6Z3ZO?=
 =?utf-8?B?d1FXUVlNcFJ3bWk0QTllMGMyMWhkSExIbG0yRm4yZ1g0a3NNQS9MejJHZGFQ?=
 =?utf-8?B?RG1POUYwUnlvYmVidUJmMVRwL2Z3WVRJSW1DNmJGLzd0ZEcwaERITmtrSitL?=
 =?utf-8?B?MDZ2RXRHcmowaE1MMksyNjJ0clo1a1JoMXdsMm9VT0J3SUkxMUptdG5GbFRo?=
 =?utf-8?B?azRZVWpQcWNaUUUyZld0OGVZaUJsc3QybWpDR0hjWFo3SWtFcmc0WGExa20v?=
 =?utf-8?B?bFB6WHVKVThldFV4a2dpSjFDMkh3R01uVzAxNXVSckFnKzJZdTVBK1NxM3RD?=
 =?utf-8?B?a3hMWE9IekZPN3h1S09lSFdlVDc5T3oyckFGUDFtb0RZTzd4R3FUN0luak9L?=
 =?utf-8?B?Y3prY0d0Ky9HMnJqdEIwb3FENUU3RHBhNzdDWnpzZ3N6ZTBSQTlHcitvblF3?=
 =?utf-8?B?WUhzVnl0RG5qSmxzWGpoTG5jNUxMYWpBd2NkV3J4L0NJUnJUcFY2NW9nSURv?=
 =?utf-8?B?NENlRlc4WlVRYmNXRTIvYnphNlQ4bWNlR3NYbG1FSzJGc08zMHEwR2M3NW5t?=
 =?utf-8?B?Q2JXczRZRWpLQmNjdnY2dTVNYXAyZG41alFyZGZTd21kbC9uR1Y2Wnlub3lB?=
 =?utf-8?B?UGJFcGFkQkNJMmZ3dzBMNlkvd05SZ2Q3dUJKSnZoMXduZWs2dG01KzFHTFRa?=
 =?utf-8?B?NEM2MTVNK3hkdmUvZ1JBSFhCdFVWN2NaZHlHckYvYkczZ0ZidGhJWFFxLytn?=
 =?utf-8?B?eEw1dXpsa2RtVkVyc0dKbjBRRHNreXMwcmJrWVcwUzNsRzk4UURjODBpRENI?=
 =?utf-8?B?SGlOeVhWYUI0ZzJJd1VXVlVDMWFPOXdobVRzbExIVVJ1Vk5ES0pWUEs5SDBO?=
 =?utf-8?B?WnFRZUpocDR6TW8vOVF0czg5WnZqRitBK3dWR05DKzVOWGRnTVdCbGJyUlBs?=
 =?utf-8?B?bnBuOWtZZWZwamg3QmVVVjRtY1JFSUtlVUwxTkd3NThOWjdDa3NBMDdDV2RJ?=
 =?utf-8?B?WEdhREdMWWlpUEdCczBnTnc4VzJpdXNxY081clhHZGxrek5EQ3Z5Um5rZEtl?=
 =?utf-8?B?dW9PRjZmNlpIUXJTU3lyZE5iZDNIcVVPWGo0MnIvNlMxR1U0cENHekhQMlZG?=
 =?utf-8?B?ZDB2WmJWVVdVM3c0ZzA4bXh1MzZGTzZ2ZVVua0dvVklhcGZCSmRpM281SUlN?=
 =?utf-8?B?cHNybWJMUWpBYXcraVRkT0MzeWZUeVBNbjRjU2VRQisxeHJMQlBvQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e89bb19-9c02-44f7-4d32-08da42ff196b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 12:14:25.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXOR0awGacOt5zl710zhyyRb8r094mCQhOGpQeL0f5qgqQx6rDnhRtyiseDwfP/Zg6R3PhHulp682zBY2ih9ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6174
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:
> On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
> 
>>  1. In real use case, config or any other ioctl should not come along
>>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
>>  
>>  2. Maintain some 'access_count' which will be incremented when we
>>     do any config space access or ioctl.
> 
> Please don't open code locks - if you need a lock then write a proper
> lock. You can use the 'try' variants to bail out in cases where that
> is appropriate.
> 
> Jason

 Thanks Jason for providing your inputs.

 In that case, should I introduce new rw_semaphore (For example
 power_lock) and move ‘platform_pm_engaged’ under ‘power_lock’ ?
 
 I was mainly concerned about locking rules w.r.t. existing
 ‘memory_lock’ and the code present in
 vfio_pci_zap_and_down_write_memory_lock() which is internally taking
 ‘mmap_lock’ and ‘vma_lock’. But from the initial analysis, it seems
 this should not cause any issue since we should not need ‘power_lock’
 in the mmap fault handler or any read/write functions. We can
 maintain following locking order
 
   power_lock => memory_lock
 
 1. At the beginning of config space access or ioctl, we can take the
    lock
 
     down_read(&vdev->power_lock);
     if (vdev->platform_pm_engaged) {
         up_read(&vdev->power_lock);
         return -EIO;
     }
 
    And before returning from config or ioctl, we can release the lock.
 
 2.  Now ‘platform_pm_engaged’ is not protected with memory_lock and we
     need to support the case where VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
     can be called without putting the device into D3hot explicitly.
     So, I need to introduce a second variable which tracks the memory
     disablement (like power_state_d3 in this patch) and will be
     protected with 'memory_lock'. It will be set for both the cases,
     where users change the power state to D3hot by config
     write or user makes this ioctl. Inside vfio_pci_core_feature_pm(), now
     the code will become
    
         down_write(&vdev->power_lock);
         ...
         switch (vfio_pm.low_power_state) {
         case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
                 ...
                         vfio_pci_zap_and_down_write_memory_lock(vdev);
                         vdev->power_state_d3 = true;
                         up_write(&vdev->memory_lock);

         ...
         up_write(&vdev->power_lock);
 
 3.  Inside __vfio_pci_memory_enabled(), we can check
     vdev->power_state_d3 instead of current_state.
 
 4.  For ioctl access, as mentioned previously I need to add two
     callbacks functions (one for start and one for end) in the struct
     vfio_device_ops and call the same at start and end of ioctl from
     vfio_device_fops_unl_ioctl().

 Thanks,
 Abhishek
