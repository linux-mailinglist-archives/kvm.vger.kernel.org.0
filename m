Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D074C5FF507
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJNVJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJNVJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:09:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ACD1DC822;
        Fri, 14 Oct 2022 14:09:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQVNXbW7AeG4KVVje8L5lcAkvW6FvuCMmV2ApPR31j3wtr5DyYA4sPmCH70kYm3+CFQez5CzYNmoRe1U2Tg8RBRITSxvGFursMPV52MWfbBtPkP9vd5jKt32uUo5Z6LiabGO4AZqm+QGMZALrfhWbDwW+/qgRzlQL478nvWgqEdwQe12Lekdk9+l0FVFFuGHhgVDfBQsY1n9njBG7JHElVEyxQNveKr4mkZf6qevPcqLONt1ZVBqj3pLtspRcQtHyKupGq5pTqd7unNMhgdoW6uQl4YHZ1EKZiySA9gl7cN97Xcf1b0CuRr1mFUlSyxqzrEnB3KDqnfiHn3urGaXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFfwb7Ia6RjTQLBtQ1zxJKKj2IeqG0FMS0QPRb7sPQY=;
 b=ZFinu+eX0t/hwiQ5T5ugtBaUPFlT3dNiiIuQCc1TRyzQlhhnZNHXkp1LePGEI9rrI8VzeFK6FU8HNqzLv4s/PBl140rwLZVQ9RJOoNn/UpjjiDH0MXLatzTUIINf8enL6IAHrlh1cC0FgTJj+6L+5WHorEDvk2y8078y+8zKYpA0RTm05uV0F/WmnvE5Qanqq3vgXf8GpMopF1nH8sKGEykFbjeQBpIRthFRG8R82E7NqwrmQ34GSaQ16qk7tPVQjkKpU/OJT85kXRnCXXUhQZCWIBylebDKEl+/HvONp/Fn8MwL+1rZfuhxb31P9T7b60aXafMeZ4W8Ecvff1cIhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFfwb7Ia6RjTQLBtQ1zxJKKj2IeqG0FMS0QPRb7sPQY=;
 b=vRnBPGcOPszYRUmaE1zE9EcAp6hWW8qOufRqSP7Bnx3qlYPnpShAAgikezsPB0AMo/saUCUsMV8RoxQcfN+IFZtBKJY8SDMziTKaYs83uM27BMDG9yj9qp6O50yRe5YxSTAEquZvcG7xv/DWBi/Lp4FVZeaY2Slii+WoKhsx08o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 21:09:17 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 21:09:17 +0000
Message-ID: <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
Date:   Fri, 14 Oct 2022 16:09:11 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Yzh558vy+rJfsBBq@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:610:e7::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BL1PR12MB5285:EE_
X-MS-Office365-Filtering-Correlation-Id: 33bf375b-a75e-47e0-a1dd-08daae285ab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4tuYATPjushDpxgCFQjPWuImmo3E5scs6dJZnbUBi4DSKdrS63NKjKxIbXXrvPlNhq6Ymjr6oKcONt+jC5/BomRJSXOFaltzqzMxK+nC8JkcF6CGRoqVq5PmjRsNiKWDjEDU9qzzXr0Tpk9jIH+y0pCds9Kf89h0DuPNfRH4Sgqx3y0KLNe3CGI/AfBibhRufijvLCRGd7Lif0q6ElqxdKqBJfuDkBomG/8X8+9zuCK4WPwESaTDmyjOI2Z6FhlXAv6PMVpLrSNsfYRYq9SdE0nxM3J0nUEVwcijN8JwcN06ychCDgJQHJxttsotfaMphcLFJ+75sOFbitZteFv38g5WWykwMIqu1mwRPtJ/2ItWGPYKDN/6qzQwxVIfRxOpR20H9cZ/8l9pbfrkIaC/xr9wOU2K0csQwktCS2XRe+n0yYZ2WX6QCiz2zKl3Ip5ut4+e9YCRGBtJBUmapjAnHAtQKNobwVI8zb0j6ryfgjIg+GsK9h+F2/v4PwXmgH58GmwHCxaMxthcGwAayBcdjHyyRpTRzAVYlPpITMuw4pycGMzmuBXBumj1BPQWxC1AB9dfGQkzqBmTsO5NGGlxI5yByDbDbnhQ2eRj2xBAygtXFmToFi+kasyeXemhGZTEIS7hTHlsQFNDeIQk2eDzadlf1hThzbP3E4/5e2tCuHkb9M52WmoDjP5nUGogAazipHOd01l4Iqz7jf/7pVdMKdlmnm4hMSdfUrfSL/C3+Je4oL7GOSKNyhD6odJL76vOrbQr1NmzE3N/OoFRqXGveYFvu3X8uiyoDwhPhiN1HEgwkGCUNzsw60qisA0NWfhLBvo4LjYS9nCAb3ewnZ2Gqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(5660300002)(7406005)(7416002)(2906002)(38100700002)(2616005)(6506007)(41300700001)(26005)(83380400001)(8936002)(186003)(31696002)(53546011)(86362001)(6512007)(36756003)(478600001)(316002)(6916009)(31686004)(66946007)(8676002)(66476007)(4326008)(66556008)(6666004)(6486002)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0FkbE9UWWJhbzYzTEVFa2c1R3ZLWTR3MndFcnZ1ZXcxc1dPOHVTVGt4SVQ3?=
 =?utf-8?B?dGRuRFRpdi9JNXFFNFlFR1pYQ1p5MG1XQldONnV2NDEzQWtTdC9mNEd6aVlQ?=
 =?utf-8?B?cE1sY0R6elRKU2xyUXVoY2RmMWwzVUNKZW44aGlPOEhvb05NM0lYc1o0YzZs?=
 =?utf-8?B?WlFVVEk3a0lwMGxJU09SS0pZOHRFbTQ1VW5WTWxSK0Q5OEkxNGZLeWY2Wlk2?=
 =?utf-8?B?cDh5ZW5MYmxBY0o1Z0NyZWFTemlOZ2dQamVTSm40ZVBkZWo0RUtuOWI2SmN2?=
 =?utf-8?B?ZVJKUjR3YVkyMHhmTnRqUGRodE0rSTVLQU56c0VQcGRjamZ0bXc1cHM5eStq?=
 =?utf-8?B?SHdxd1ZBWjFnOGdBOXNNWjd2OVRsVUR6RGJ1TTRzd2R4TzRrcytNWDF5Y1pQ?=
 =?utf-8?B?MHhJZ051ZUV4MllDNXZ5K2U0MzN3dmxMbDZPcnpwYjB2M2pZWkRCVGwwQ1Rh?=
 =?utf-8?B?bTBNY2Z2VUtKMXBtbVV0Y2FUbWtUTk5RZSt3WU1WbEZ0L3A5UEgzZTFsZXZB?=
 =?utf-8?B?L2c1R0Evb0F6OWRFTlJ4T3RnZ2pOSCtNSC9aZ1FSdGI0Y3ovMjBGSG0rQWRZ?=
 =?utf-8?B?ZmxzREU2VTd3bUU0NFFxWmhkdVpUNEc1QTY1bndTendRV3ZNbGlGZzIvdlky?=
 =?utf-8?B?N2xLWjhKc2hKdFp4T2RVemRPWC9vS1U2d1l2cHptUU1xSWhNUWE1WWhOYzlM?=
 =?utf-8?B?dGE1RElXQzBRd3RHVzEyYmdkS0VVbnBUVm9wbGYyd3dPVzh1eVljT015aE9G?=
 =?utf-8?B?UDZtU05LRlBLdXJmMDEzZnRua2E5VVh3OEI1Snp1Vk15V05ZNUc4WG1Wc1BN?=
 =?utf-8?B?bU1yaFNjZG5yR3YvUTd2UVdCRXIrTFlqcUtPSE53UEx0QWNTUWRYNTc0WVZG?=
 =?utf-8?B?UVIwaVpWampadTd5c25mUFg3ZVNIUURHdjgwekhqUmdaMjUwSHc5ZzRxazB5?=
 =?utf-8?B?VnRLaEo3N2FzTXBsNi80akF1S29aTzU2Q1VKTTY2REhBSTdCMmxFbVkvLzBY?=
 =?utf-8?B?NjlDMDFXd2NBZlpoUkFxdnJDZzBvQXFGT0hxN3d1OEpVblNtajB6VWR0ZlBh?=
 =?utf-8?B?MWFRM1FpbmRnRm1SRTBJOXhaOWJQVW9JU094OVBjeVJKZTZLUGdmbVFOaXU3?=
 =?utf-8?B?MnRYS0NIT0F3Rnc3QXFveFJ4T0orTSt0MjIwT1BLcHZzTUo0UklTajFkd3Ey?=
 =?utf-8?B?dDRCOVU5aGZLWnQvZSttK0gwQ1c2Z0FRWk1EbG02Znp2ZytrMFkwZnVlR2Y5?=
 =?utf-8?B?ZUtTQkhoR1VnUzlSWEcxQ2duQmtHdHQ5TExvQ1ZZL2l1SzUwU3ZOYzF6aENR?=
 =?utf-8?B?dFNTRXdkWFVEMnowZ2VrbXphY1RtMys5L0xiS2tacVNBR1NaWUt1cEVTdG9q?=
 =?utf-8?B?NTJBZnREU1hwb2pUUVZObDd1STdFcWo4eXRid1pQcTZiM0ZOTGVwb0huZ0Jq?=
 =?utf-8?B?TERneFlxRXRYcTBPQUVWSkN5MnN0eTgyQTM2dEU4OW5qbCs4enRTSGFkZlMw?=
 =?utf-8?B?bHFRcjBVSVd1NnRobk1lc1lwSnJNOVVGNmo2bHZRVk5Ec1U4OTM2dXQ2QnhY?=
 =?utf-8?B?MXFNZmE1MDg5RC9FcWhDaEY1RStzVTduRWlJbGYyeENBSnVZdDdIb0x6cVcx?=
 =?utf-8?B?cWl0dXhFem9MUGhnMW1pVWZBR3JFTlp1Sm56WnZNdCtRcDI2V25XNkRvNWdR?=
 =?utf-8?B?ckVHSU1NS2txWmlnZVhrWU1wK0NpbUJHQkQvbmRIYWkydlk1VDl5KzZKazVY?=
 =?utf-8?B?NWhLUFBTM0VqVmpLQ1doczFYTnpucDVQWjcrSFpMWWVXWlVKUWVWQmRWYWE4?=
 =?utf-8?B?RVdvZzVuSmJYZlRHUkdTSzhCaG9DRnEvWjhTdEZSakYyZUx1S0huQWVvbGpx?=
 =?utf-8?B?TC93Ly9QUklmUVZ0MnVoS2l1VFFRRXNSaG1PbERaSUN5OEN5Q0UvNlFabjBH?=
 =?utf-8?B?WmhaUmhidGRiZG5xVTRZVzhIRWZWWHF4dkpFVkFITWxYOTIrZ1ZLOW9qeldJ?=
 =?utf-8?B?WGNaeEdFUW8zc3R3QVFxTkNhdXpLVjlrL1JGbE5qVElZbGQ0YUd5WkVkelJ4?=
 =?utf-8?B?K0hDM1ZpQ3lKTEIycU84TDkzejJZdlVBdFc4U2dIVmZRSmJMdUFVTkFhWVNT?=
 =?utf-8?Q?ynOLJ7s0hpUAhHFwMfxmV8koL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bf375b-a75e-47e0-a1dd-08daae285ab6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 21:09:17.2220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+dmuQlzjT0iyDW2peREH0XfStT89gCFdE/rC7Tti7tFS3XQO2NLucSl5HbI2MvnffyW5hVjFO4rFGnExqSSXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 10/1/2022 12:33 PM, Borislav Petkov wrote:
> On Mon, Jun 20, 2022 at 11:04:29PM +0000, Ashish Kalra wrote:
>> +static int __sev_snp_init_locked(int *error)
>> +{
>> +	struct psp_device *psp = psp_master;
>> +	struct sev_device *sev;
>> +	int rc = 0;
>> +
>> +	if (!psp || !psp->sev_data)
>> +		return -ENODEV;
>> +
>> +	sev = psp->sev_data;
>> +
>> +	if (sev->snp_inited)
> 
> snp_inited? That's silly.
> 
> 	snp_initialized
> 
> pls.

Yes.

> 
>> +		return 0;
>> +
>> +	/*
>> +	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
> 
> 	/* Clear MSR_VM_HSAVE_PA on all cores before SNP_INIT */
> 
>> +	 * across all cores.
>> +	 */
>> +	on_each_cpu(snp_set_hsave_pa, NULL, 1);
>> +
>> +	/* Issue the SNP_INIT firmware command. */
> 
> Useless comment.
> 
>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Prepare for first SNP guest launch after INIT */
>> +	wbinvd_on_all_cpus();
> 
> Can you put a wbinvd() in snp_set_hsave_pa() instead and save yourself
> the second IPI?
> 
> Or is that order of the commands:
> 
> 	1. clear MSR IPI
> 	2. SNP_INIT
> 	3. WBINVD IPI
> 	4. ...
> 
> mandatory?
> 

Yes, we need to do:

wbinvd_on_all_cpus();
SNP_DF_FLUSH

Need to ensure all the caches are clear before launching the first guest 
and this has to be a combination of WBINVD and SNP_DF_FLUSH command.

> ...
> 
>> +static int __sev_snp_shutdown_locked(int *error)
>> +{
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	int ret;
>> +
>> +	if (!sev->snp_inited)
>> +		return 0;
>> +
>> +	/* SHUTDOWN requires the DF_FLUSH */
>> +	wbinvd_on_all_cpus();
>> +	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
> 
> Why isn't this retval checked?

 From the SNP FW ABI specs, for the SNP_SHUTDOWN command:

Firmware checks for every encryption capable ASID that the ASID is not 
in use by a guest and a DF_FLUSH is not required. If a DF_FLUSH is 
required, the firmware returns DFFLUSH_REQUIRED.

Considering that SNP_SHUTDOWN command will check if DF_FLUSH was
required and if so, and not invoked before that command, returns
an error indicating that DFFLUSH is required.

This way, we can cleverly avoid taking the error code path for
DF_FLUSH command here and instead let the SNP_SHUTDOWN command
failure below indicate if DF_FLUSH command failed.

This also ensures that we always invoke SNP_SHUTDOWN command,
irrespective of SNP_DF_FLUSH command failure as SNP_DF_FLUSH may
actually not be required by the SHUTDOWN command.

> 
>> +
>> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
>> +	if (ret) {
>> +		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
>> +		return ret;
>> +	}
>> +
>> +	sev->snp_inited = false;
>> +	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>> +
>> +	return ret;
>> +}
> 
> ...
> 
>>   void sev_dev_destroy(struct psp_device *psp)
>> @@ -1287,6 +1385,26 @@ void sev_pci_init(void)
>>   		}
>>   	}
>>   
>> +	/*
>> +	 * If boot CPU supports the SNP, then first attempt to initialize
> 
> s/the SNP/SNP/g
> 
>> +	 * the SNP firmware.
>> +	 */
>> +	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
>> +		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>> +			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>> +				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>> +		} else {
>> +			rc = sev_snp_init(&error);
>> +			if (rc) {
>> +				/*
>> +				 * If we failed to INIT SNP then don't abort the probe.
> 
> Who's "we"?
> 
>> +				 * Continue to initialize the legacy SEV firmware.
>> +				 */
>> +				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
>> +			}
>> +		}
>> +	}
>> +
>>   	/* Obtain the TMR memory area for SEV-ES use */
>>   	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
>>   	if (!sev_es_tmr)
> 
> ...
> 
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 01ba9dc46ca3..ef4d42e8c96e 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -769,6 +769,20 @@ struct sev_data_snp_init_ex {
>>    */
>>   int sev_platform_init(int *error);
>>   
>> +/**
>> + * sev_snp_init - perform SEV SNP_INIT command
>> + *
>> + * @error: SEV command return code
>> + *
>> + * Returns:
>> + * 0 if the SEV successfully processed the command
>> + * -%ENODEV    if the SEV device is not available
>> + * -%ENOTSUPP  if the SEV does not support SEV
>> + * -%ETIMEDOUT if the SEV command timed out
>> + * -%EIO       if the SEV returned a non-zero return code
> 
> Something's weird with those args. I think it should be
> 
> 	%-ENODEV
> 
> and so on...
> 

Yes, off course %-<errno>

Thanks,
Ashish
