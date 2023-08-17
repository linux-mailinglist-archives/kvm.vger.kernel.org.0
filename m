Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D2780033
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 23:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355458AbjHQVzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355515AbjHQVzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 17:55:08 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EEA30DF
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 14:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAAJTord9VVOJKaGe/beQ6oN8YNx2GH29S4IdskF1ljMjrEyzaRfmKftgLwH/kiHDcM0S2DFSA7+7ZvJqATR5SZ4liOWnVDR/D27jtsH5gH6NrNY7COqLTt1rTKJPkz2pTFQZJuYkQSOg1Mwt7eP0aHXMmk2sYf0mfPYgMT/aY1BosVHz/j+jUIBuroHaXCNINII2bK5Dl6NDItzolyISl3qID32u0cuAVBKcxDLy2T3p/G7fFVhqR7pSSQcliI/MhtOYbBvfivKoGcEahZuFRhMYsIJIaU57o11TGg3rKfxh/BShpRfRhD91csuWyRREIytPYR1Nzmr98bo1OCs9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UB5MHsrYBSiKTRGnimez2r69JaEWNTXEhZRHPSZVSr0=;
 b=fUEAEeVnwEpXuHMBfROttr4bNC+cyQK03rKjBG3dhYGjoAF9EEN3bnBmy99bwBAjbLkKq3VWhn7AMWl9KaT9zxkmUfxP9y2JL8xiPF0JCO2s8L9hvJCz2xVoNPrKfmaKuDnO2/LCI7y2kQdlFl0/jeCCz8fcKtU2WH2a0/bkqCh7dlANWaxr3inTO0y+IuZtfXynsv6zz3VDGaqK07OiAq3tzB2moVYyDd/WchF09OrbuLJLdUoSf8EFUE2wMFvcDe4I+Xsf04kFVIy2erMJcr4tcMvpBcaCKOyHg8Qk7BFzMbps0hQFUGFALboLR1BBMZHlnUPmnKRcC0bS2FCj9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UB5MHsrYBSiKTRGnimez2r69JaEWNTXEhZRHPSZVSr0=;
 b=ePQW7gJVb2JqaWt4fJ4xV7rb+W0Xnwc/wGhdIrBDFkftODpVqBCrFtLRkJHu5NEo8g1DpqESSyJUYrS3aM+pn4tpb4NI6lfpUabRxSGnu9w37r12Tccub2QFHl8o5ANBurzF/HlyIyhLDm6TaV25/tx7uTJ6a57uh55EXErCuls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 21:55:02 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6678.029; Thu, 17 Aug 2023
 21:55:02 +0000
Message-ID: <6289e41c-9296-ae4d-f7cc-c8bfc37bfdea@amd.com>
Date:   Thu, 17 Aug 2023 14:54:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [awilliam-vfio:next 41/50]
 drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Function parameter or
 member 'pf' not described in 'pds_client_register'
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <202308180411.OSqJPtMz-lkp@intel.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <202308180411.OSqJPtMz-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0032.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::6) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a53264-e42d-4a21-dac0-08db9f6c9b83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yzi8dQ0H7nCvuf25jJ9eM0wDH/skKdducAfy/l2rM8XAj/0AtMgjp43pdy/vHQlw7C2JdVMp5jEc2ZUI18Qs6fNX/VMYT+fXB8nk1oIrFBM2twgBDjRXigNJrFTEvTUzWQOJNfwlovSkq+IPFHTHYV5onDePbDxaRC1qBK+Xkd6qzvxZiSru9jqI2B0LsNdDe2Uh2aYNL2CXm92u0z9NgfoRRnAzddDyoywx4rIZFSrpHOn9Q2XmCu/IdT1pkbzUMVe/++KCXyDYqYa/3drTnAnB3DcOXqBfdhIRLXnxn1o7vmBnJNFoIgrod9jVJwH5AxvpiVZdcGPAWYgDhif5AejdNBZB7r7UWf9TSdb2cqu5xwXS9PuCRD0hvmaKwt07k7q/nPxHs+Ywux29847t29EZPd9FwjKZJKMXd+Ddt5zgTJU0mhYlgr4aFWB6xPIBN05VbXpdCqO9Dusk26LsKJ8cF+nSSLgxaddmNdy6AXSO3RQEYeK0c92ek+g8TlD6pbH3RA5xNoVNm3tJgPeakqjTVnokaMvvrM6xPSAq2KuhiRSyIiVA5asnE+SPTk62yAx8Bcgc6+TZAKv6H/yoJ5htfITx3k99hOES/nkty0M59Gb6CjBX1DTf7qtR8oq8ZipI/sh+RIYgu+6VnOVjmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199024)(1800799009)(186009)(31686004)(36756003)(31696002)(38100700002)(478600001)(966005)(2616005)(5660300002)(66556008)(66476007)(6506007)(6666004)(6636002)(53546011)(6486002)(54906003)(110136005)(316002)(66946007)(6512007)(26005)(41300700001)(8936002)(4326008)(8676002)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z28vNm9RZk9FZkxXY21ZZkFZQmRIZzdWeExicWVwS21iSVp4WjdTbkk4dFVY?=
 =?utf-8?B?OWtubCttcGtseHF5cnQ5OVJzTExuMzZDR0g5ZkxuNHFaM21JYWIxMnpvaDUy?=
 =?utf-8?B?VmtKNDZuOGR5WkVoRmw1c1hqdHZpYjFORFJxMG9qdTNnYURPZmN5K29VMXJq?=
 =?utf-8?B?TjU2M0Z5MTNZVlB6MVNKVnNNckNHUXFkS2N2V0hDS3FjQVpqSFNMaGxPcU9D?=
 =?utf-8?B?THY5VXNZb2RSSkN5a29UcTlIUy9XbDNhRVpuZHBOSEYrMzg2R1I4aDBQbXp0?=
 =?utf-8?B?ZWM5b2EzVk1KeE1LckZDUitQTmJKTDQ2K1hqMDdwa0pmY0VCd294TUJKRFE0?=
 =?utf-8?B?VVEyNXd0N0ZzR1BUTHJDcVVMSTZXNGltWVlKbElKQTdZSlZIK1JyV0p4NWZN?=
 =?utf-8?B?MU5aRXFzclcxeUQvd1RTSUp3T1Y0VkZOTzdDOVpLenBNSWxIcEE3ZmU4SGFC?=
 =?utf-8?B?akZYWmlpTEQrYzV6WWRsN3p6TytqYjAwNnR2bEpMWHhQU29LM3BTMzY4dE9K?=
 =?utf-8?B?dkF1VHlZWlQ3UjJJUUJ0bWdjN1JzYVdya255WUNVRWczSEY4VWVhSk1LZTRw?=
 =?utf-8?B?YlVBRHRzOHV5T2IyVUQyTUhkczYrcTlxRUluMTFrYngvLy9DSHB4b2Jnd2Qz?=
 =?utf-8?B?QUh6Z1FlUUVrZFVZWnBudmV1bklSK20xc2t5K01RTHJGWHk0SW56RWhuVGdu?=
 =?utf-8?B?SjJvLzdpMlp5eExBTjZuTjNkU2NQTTFRTmZUcGFaT2FIWUlxOUxrYzlldU1m?=
 =?utf-8?B?ZnBxM01lalRaZzRRZU02cG53bmt4c1ZWSlZtTk44TUxheXhQSkV3b2Q3eFhi?=
 =?utf-8?B?MjZLTmZaN3pGeFVMdURyK0xybmRsMjJyVVZEOE5aeW5FS1ZaZjc4ZnNUYTVu?=
 =?utf-8?B?b3ZGbldkS1pkTzA3dEhlSzlSRkN6azVJZERMU1dIL01MT0FDSWxwTitEa1ln?=
 =?utf-8?B?SFU2cUZ1d2tqN1JqOVJrSXAwWXRMNElGMW8zaGRLbmJ3cy96NXJMaVV0Y0Vs?=
 =?utf-8?B?NDExcGpqUEJWcTB1L0hJYzluMXpSWk1LaDl5d212ZUpxUUZLYlhyczBOVzg1?=
 =?utf-8?B?NFdJTDg3OWU5dXhCYjh5RVRKdThxQlFXdTUzZ3cxeDlKN3Z0V25PbE1WaG95?=
 =?utf-8?B?QzRMbG55Q0dXbDNFTUVWMEl5SWhleWpYMHJGTFFqN3lCSmdCMTBFMkxLR0Nh?=
 =?utf-8?B?ZDhVcVJOUG5PdEF6dzdaRS9EVzB3aTc1bStETmtiWEErUnNlUXMwOVFadEVp?=
 =?utf-8?B?ZGIvVlpDL1hXYStIcnQ2ZEw5Q1ovT0E3aXZRblhhVTZKNXAyTmFySkM4SW0x?=
 =?utf-8?B?V0RqUjlja1VPelBNenNVUjJsdzdVTHFkOGZPV2ZqNG1Ubkw0cFFlVjJBZUg2?=
 =?utf-8?B?dE43TVJCR3VvemxKRytBS3VRaUNMTkhuRkZMRlYrYnBnYkRpdmFSUmxzQXln?=
 =?utf-8?B?aUV2dkROcnJQR0VsL05pczBiZWxDbDdkcytqMFA5TzFjMHBXM2RnU3VvUThD?=
 =?utf-8?B?QysvWk5OUExROU5IQnl4ais3d25Zd3FGRForb3pLSkFYTmdQNVU1OHY1eVhE?=
 =?utf-8?B?b1VGSUJDSVYvWndFdEZZbmZSalFRQzd3TFJTaWpyK1U0L29GeFppQTlDbWZv?=
 =?utf-8?B?YVdKcCtEMGdyNVhURHExL3FzRk5MUjBveWJPMEdoTklDdzdTMWpMOXpLYVlG?=
 =?utf-8?B?aFJBT21vaHpZTWRjendjMFJMK25LcGQ2VzJjSURJT0F5cXY3R1NtcEsxQXhq?=
 =?utf-8?B?aWxTZERGMDgzWElZcm1DNXl0RHdsTm8vZmloUk9XbWhKUmk4VFp0Z3RXSGVy?=
 =?utf-8?B?dUwzMDl3a3JZdHRWUGZqR1hGT1QzL3ZHbG9XWjBtOXNvN1ZPeXhLUnU1L3li?=
 =?utf-8?B?dTU0S00vYmNLVXBPYXZJak44TVlPcEdjWjE0dHdRZVBHMU9qVlFNWGZKeVFr?=
 =?utf-8?B?cEgyOHdKTFVZWTRBVGw1QnZjdGprY3VURkpGS21oUXhka3pLZUpVUE1uM2dQ?=
 =?utf-8?B?UFFYMG1FSmVPNXpqVWFGckFJWmVGWHc2aHhnNFhwQmFVVGJsQTA3aUpVSG83?=
 =?utf-8?B?eWk3TER6d2tIazR3eFo0WUNFcWRnRTNFSWlyQWQ5RVkxc01IKzRXVWhRQXlm?=
 =?utf-8?Q?KxXEvGVRbLT5q9doPVY3sWUx0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a53264-e42d-4a21-dac0-08db9f6c9b83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 21:55:01.8676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /O2KpGBuwU3WSSbNJIrFPJAmWpGfDJwT1pa54xOWWN+QhrhO8nFIv7B6yBNOq/YN1ZHkFhHUuZE8k/842FLzdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/2023 1:32 PM, kernel test robot wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> tree:   https://github.com/awilliam/linux-vfio.git next
> head:   a881b496941f02fe620c5708a4af68762b24c33d
> commit: b021d05e106e14b603a584b38ce62720e7d0f363 [41/50] pds_core: Require callers of register/unregister to pass PF drvdata
> config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230818/202308180411.OSqJPtMz-lkp@intel.com/config)
> compiler: alpha-linux-gcc (GCC) 12.3.0
> reproduce: (https://download.01.org/0day-ci/archive/20230818/202308180411.OSqJPtMz-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202308180411.OSqJPtMz-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>>> drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Function parameter or member 'pf' not described in 'pds_client_register'
>>> drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Excess function parameter 'pf_pdev' description in 'pds_client_register'
>>> drivers/net/ethernet/amd/pds_core/auxbus.c:58: warning: Function parameter or member 'pf' not described in 'pds_client_unregister'
>>> drivers/net/ethernet/amd/pds_core/auxbus.c:58: warning: Excess function parameter 'pf_pdev' description in 'pds_client_unregister'
> 
> 
> vim +18 drivers/net/ethernet/amd/pds_core/auxbus.c
> 
> 4569cce43bc61e Shannon Nelson 2023-04-19   8
> 10659034c62273 Shannon Nelson 2023-04-19   9  /**
> 10659034c62273 Shannon Nelson 2023-04-19  10   * pds_client_register - Link the client to the firmware
> 10659034c62273 Shannon Nelson 2023-04-19  11   * @pf_pdev:      ptr to the PF driver struct
> 10659034c62273 Shannon Nelson 2023-04-19  12   * @devname:      name that includes service into, e.g. pds_core.vDPA
> 10659034c62273 Shannon Nelson 2023-04-19  13   *
> 10659034c62273 Shannon Nelson 2023-04-19  14   * Return: 0 on success, or
> 10659034c62273 Shannon Nelson 2023-04-19  15   *         negative for error
> 10659034c62273 Shannon Nelson 2023-04-19  16   */
> b021d05e106e14 Brett Creeley  2023-08-07  17  int pds_client_register(struct pdsc *pf, char *devname)
> 10659034c62273 Shannon Nelson 2023-04-19 @18  {
> 10659034c62273 Shannon Nelson 2023-04-19  19    union pds_core_adminq_comp comp = {};
> 10659034c62273 Shannon Nelson 2023-04-19  20    union pds_core_adminq_cmd cmd = {};
> 10659034c62273 Shannon Nelson 2023-04-19  21    int err;
> 10659034c62273 Shannon Nelson 2023-04-19  22    u16 ci;
> 10659034c62273 Shannon Nelson 2023-04-19  23
> 10659034c62273 Shannon Nelson 2023-04-19  24    cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
> 10659034c62273 Shannon Nelson 2023-04-19  25    strscpy(cmd.client_reg.devname, devname,
> 10659034c62273 Shannon Nelson 2023-04-19  26            sizeof(cmd.client_reg.devname));
> 10659034c62273 Shannon Nelson 2023-04-19  27
> 10659034c62273 Shannon Nelson 2023-04-19  28    err = pdsc_adminq_post(pf, &cmd, &comp, false);
> 10659034c62273 Shannon Nelson 2023-04-19  29    if (err) {
> 10659034c62273 Shannon Nelson 2023-04-19  30            dev_info(pf->dev, "register dev_name %s with DSC failed, status %d: %pe\n",
> 10659034c62273 Shannon Nelson 2023-04-19  31                     devname, comp.status, ERR_PTR(err));
> 10659034c62273 Shannon Nelson 2023-04-19  32            return err;
> 10659034c62273 Shannon Nelson 2023-04-19  33    }
> 10659034c62273 Shannon Nelson 2023-04-19  34
> 10659034c62273 Shannon Nelson 2023-04-19  35    ci = le16_to_cpu(comp.client_reg.client_id);
> 10659034c62273 Shannon Nelson 2023-04-19  36    if (!ci) {
> 10659034c62273 Shannon Nelson 2023-04-19  37            dev_err(pf->dev, "%s: device returned null client_id\n",
> 10659034c62273 Shannon Nelson 2023-04-19  38                    __func__);
> 10659034c62273 Shannon Nelson 2023-04-19  39            return -EIO;
> 10659034c62273 Shannon Nelson 2023-04-19  40    }
> 10659034c62273 Shannon Nelson 2023-04-19  41
> 10659034c62273 Shannon Nelson 2023-04-19  42    dev_dbg(pf->dev, "%s: device returned client_id %d for %s\n",
> 10659034c62273 Shannon Nelson 2023-04-19  43            __func__, ci, devname);
> 10659034c62273 Shannon Nelson 2023-04-19  44
> 10659034c62273 Shannon Nelson 2023-04-19  45    return ci;
> 10659034c62273 Shannon Nelson 2023-04-19  46  }
> 10659034c62273 Shannon Nelson 2023-04-19  47  EXPORT_SYMBOL_GPL(pds_client_register);
> 10659034c62273 Shannon Nelson 2023-04-19  48
> 10659034c62273 Shannon Nelson 2023-04-19  49  /**
> 10659034c62273 Shannon Nelson 2023-04-19  50   * pds_client_unregister - Unlink the client from the firmware
> 10659034c62273 Shannon Nelson 2023-04-19  51   * @pf_pdev:      ptr to the PF driver struct
> 10659034c62273 Shannon Nelson 2023-04-19  52   * @client_id:    id returned from pds_client_register()
> 10659034c62273 Shannon Nelson 2023-04-19  53   *
> 10659034c62273 Shannon Nelson 2023-04-19  54   * Return: 0 on success, or
> 10659034c62273 Shannon Nelson 2023-04-19  55   *         negative for error
> 10659034c62273 Shannon Nelson 2023-04-19  56   */
> b021d05e106e14 Brett Creeley  2023-08-07  57  int pds_client_unregister(struct pdsc *pf, u16 client_id)
> 10659034c62273 Shannon Nelson 2023-04-19 @58  {
> 10659034c62273 Shannon Nelson 2023-04-19  59    union pds_core_adminq_comp comp = {};
> 10659034c62273 Shannon Nelson 2023-04-19  60    union pds_core_adminq_cmd cmd = {};
> 10659034c62273 Shannon Nelson 2023-04-19  61    int err;
> 10659034c62273 Shannon Nelson 2023-04-19  62
> 10659034c62273 Shannon Nelson 2023-04-19  63    cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
> 10659034c62273 Shannon Nelson 2023-04-19  64    cmd.client_unreg.client_id = cpu_to_le16(client_id);
> 10659034c62273 Shannon Nelson 2023-04-19  65
> 10659034c62273 Shannon Nelson 2023-04-19  66    err = pdsc_adminq_post(pf, &cmd, &comp, false);
> 10659034c62273 Shannon Nelson 2023-04-19  67    if (err)
> 10659034c62273 Shannon Nelson 2023-04-19  68            dev_info(pf->dev, "unregister client_id %d failed, status %d: %pe\n",
> 10659034c62273 Shannon Nelson 2023-04-19  69                     client_id, comp.status, ERR_PTR(err));
> 10659034c62273 Shannon Nelson 2023-04-19  70
> 10659034c62273 Shannon Nelson 2023-04-19  71    return err;
> 10659034c62273 Shannon Nelson 2023-04-19  72  }
> 10659034c62273 Shannon Nelson 2023-04-19  73  EXPORT_SYMBOL_GPL(pds_client_unregister);
> 10659034c62273 Shannon Nelson 2023-04-19  74
> 
> :::::: The code at line 18 was first introduced by commit
> :::::: 10659034c622738bc1bfab8a76fc576c52d5acce pds_core: add the aux client API
> 
> :::::: TO: Shannon Nelson <shannon.nelson@amd.com>
> :::::: CC: David S. Miller <davem@davemloft.net>
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Fixing this now... Should have a patch up shortly.

Thanks,

Brett
