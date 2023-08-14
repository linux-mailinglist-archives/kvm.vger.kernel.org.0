Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D64477B928
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjHNM7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 08:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjHNM7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 08:59:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A81B5;
        Mon, 14 Aug 2023 05:59:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iK6dDexPZB8geHaIEbfvCVOvnNqkUxf95mQRmliyFoDKFOe5RyjpYnYQ3cH62z6ajpz1CAAfyekj93bIdpR2WuuRiPu2V0jfheLs0d8U6j3WzVSKpfPW3/YGtvo9nUF3gLIy0WSJ3kVuclTG+IwFfn0iQnPug57/4Co6Nj5G6xbZMGesT7947C2jyRHLBucr+ko7i0XFkY3x3xVw9etdyG07vUu8uJiuz4g76u2yPAD42KDD+HyUqnni/+SU2Uobw93tTK0PWPM+wE19YV6EAFw2Ck702D7lWCz3WO7nujnR6Ik1AAPkyMbinVSSsjvy7jaWbAX2fyrtMj1XOYSAyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FBCR7liC7f8sFBuQ/YuYz+qD51QGv27WZ96rg1wUMc=;
 b=kqX/JF9TjvV6Hwq1q0KOzPpPcxukd1Iec53rMI/zAzMuFCiFiJNVfVJbnj1dZglnTx2Bf6dsbJmqEyKSPtf7bVhuGWcQSqrQLCWuLOAoUIlr5PawJ4KIlBz9HvGNQ3zQWvkNHeT0VUNshNFB/z2AHyGcjx2BnCOSRX7mjj/oF6qftIBIZPYlwuytzE6q+4NYmqCFz/3PDmwRxh3UYac7q1i9Z5RjKh0HDUKprb9gqa6xFNtuwiWAfDIBngC+dAxH2/glu3dzgiuS7lk2PGVqdtVhNVI8qpSvjXkQi4+AZyUwdGUe+r0NNnkHVlVyXIg01H9MkfQiYhMhxMZuLc3N3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FBCR7liC7f8sFBuQ/YuYz+qD51QGv27WZ96rg1wUMc=;
 b=NUib0hZMqCq1jiJ6EYpG/vwBWDbfvROLGPnaM1yzUm7skbSlYE56kA2RCPxOiOG8ajVUEXsIIZDjijczy4flS2/oCCSoWnMcClNzstI57N6Pj7K8gf1sJljaVyXixiN5Ijr5vx1vvhcDlzDx3NFxwngxbSbSGTiXv9rM56vgPyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 12:58:58 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 12:58:57 +0000
Message-ID: <9a5b914e-4a05-d7b1-03da-3e7c1cc7cb3b@amd.com>
Date:   Mon, 14 Aug 2023 07:58:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/3] KVM: SEV: only access GHCB fields once
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com
References: <20230804173355.51753-1-pbonzini@redhat.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230804173355.51753-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::19)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: d575d012-ebba-417b-356b-08db9cc6387a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yn/+VBpXHE3FkbRKlSxkkUGOTwN5zkUvp3bXc+jvXm6m3RhAYdccqDwGAEsd370+F2qkRR0CZNTCAJoeLwd5umrYhq4j9KKbOlvOABUaAQyWpeQXNezojIc3BegUwUq4fiDJsmFaQzz6mxUOHmVKuTc6vjpaXQabSlXkcUx4hOoyDO6sDtNB9AjYyRCTbVMq4nKPH907ttKnllxgSF1xMcMz0O2uMXyg6hNOmrBMwm2516yNP2F7EiPMJuIqZIJ56dSMKk60jBKVJfBgY71f2Os1CgP+GY83L15fFdBcI/qGV592b2Wcn/nAX+cZYqEBASsOMqbwC1/CL2+D+D5Z4QdFXD1T+xb/vhMkKVCLSHwXrIP5RDiI1Ibywit6P+DSIAVSoGJrIZDcwsYw9IOPkCZASpN1ZEOYnSBmcH3pggio1qPuyJMj3Fc76y+IRvxzS2eHE+siHqEnMIRAGzashjgLvZ0azCol11SxF1yPRWzyq4nUsjH+sMvbpBPQzhXXesLQoWQMlZ1066AwOFczHHYcVQElfvL7iB205lgMDivwkCyExOW6yT0/6/VjHFmVOHBI4THv63vsXFoEDxQZpn9qlNJj4SQ0s7jTVvzaDQh9pnFZfDsswB1gV2muJikeq2g/ltoHAANZmnM8i1SHkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(396003)(366004)(186006)(1800799006)(451199021)(83380400001)(36756003)(31686004)(86362001)(38100700002)(41300700001)(478600001)(66946007)(6512007)(316002)(66476007)(66556008)(8676002)(8936002)(5660300002)(4326008)(2616005)(31696002)(26005)(6506007)(6486002)(2906002)(6666004)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmlSK0pyK3lmWU01cWpjelJzS0dBcEExYWpQVUVTdVk1SkRsckJ4dTk3RDlp?=
 =?utf-8?B?L0hqclBQRUxoVUI4cExZNmVRdXh5S2RVdDB0YVNvZzd5L05hRnFyakluNzJT?=
 =?utf-8?B?OHdzTDRMR0p6QXV3WGN4L0dmWmFDL0Fac1hwK3gvM2RCT1d1d3hHcGpVN0l0?=
 =?utf-8?B?N3FqTnRKU3pIVnhGZkhQMlBWNjJySlpjWDJmcm1EZ3NhL0pJaFErc1NjVlBB?=
 =?utf-8?B?VWJ0aHlKK0R0NG1kU0JBNkVqQVJ6dTBYMXZURC9Sanh1dnF4bWdNTzNzQnQz?=
 =?utf-8?B?RzJxakswZTlmQXkwOGtpQ2ljMGs4d3crYUJHb254U05JT1VkOWdkWmJ4U1FY?=
 =?utf-8?B?RzJHTDFkSmtwc2VMUGlJWFFJNkJtVDc0eVJVNkxvdWdpay9Pa1lQckFmaTgw?=
 =?utf-8?B?NmVmK0NNbnhWOTNyQUwwY3hYSDkwdUM2ZjJRcEJFaW92UGUxd3owL0ZSYmdU?=
 =?utf-8?B?WE1jY1NHVC9zZXJnZlNieW5RR0UxWDJhaTlPQ05SeUFFUWRwWDc5bHJFa2No?=
 =?utf-8?B?Qk04SHo1eXllM25WclcwQ0xXVTU4QmY5RmxwQnlWSnEvZWp2aENQUmJJSnhx?=
 =?utf-8?B?NnU4bjFnQ01rSWYyelZ5c1hwTDJBeWM0Z05IZTlqczVKTXBZMzQyQ29yeHRF?=
 =?utf-8?B?bFVKOWI1TFZVVXc1UlMwZXZsY2xlMlkzcnVGdldwL3FtTE05N0wrdXU3bWNY?=
 =?utf-8?B?MEFTZm1uZFpzVXI4dCtic3FXSU4xUncxV2YvdkIwa2ZWN3lPaVYvZGFRRzM4?=
 =?utf-8?B?Z0ZWWFU3M2IvMWlTSzU4NXBLemZscWN5MHliZm5QN3NiNFJDcW1jWFI5Zmg0?=
 =?utf-8?B?YW95bzYxc0JWUEQ4SFdXaFJtREdldlpUVHdNS0lVK0w5cmpKOFVlZFViWE9s?=
 =?utf-8?B?bHMreGxLQUZ3dEU0OVFXOHRmUUZRSytIcVg2ZzZLaXR1d28vaElCOWpDLzdB?=
 =?utf-8?B?YkZIcnAvOVlmR0JhMWNUNURXdlpNbEFOcDlsRjZTK3QwMWJDRHZZWGg4d0hs?=
 =?utf-8?B?aDZxZk1YZjB2bm1VWXMwYXFmck1uN0VVc1V4aEcrZk5XZ2lnaWtsZm1hZE5F?=
 =?utf-8?B?TVhDOEtPOGs3MnA3dE1vM2NGYjJBRk1Wemt1S055M2R6NXJXV0hoQjFGQ2FL?=
 =?utf-8?B?WXV5RGlsN3htNjAzdGtsdGtIYXd1bjJvQzBSTmp5VVlLU3VFNHNBSWVBOFZk?=
 =?utf-8?B?S01vZ1V1YXhuTUxnTUNqcEFrb1pscnkxUUx1ZGM1Vmc5WXF5Rm9mVzh0dGNt?=
 =?utf-8?B?WjJEU051M25zRFIzQ2JnLzFpQ3hscFZKTTJ5L0MzclhRRzBCVU1KSDdDdlg1?=
 =?utf-8?B?a05RTG5xd3I5TjVWOE94TXNPK2xQZHBmMnY0TDRLUG1SWEF6N1M2a2FtbU1o?=
 =?utf-8?B?UmM3TVZtNHNVeitCZXQxUVozSXFveDhDM3J0UW9CRWh4WjdFejMvSUorMDlt?=
 =?utf-8?B?aXlTRjhWQlJqU0EzdkJSQlFVUFp2SWNQL0RSUEZ1b1VTQlZiVWxlN0d3c3Fo?=
 =?utf-8?B?UVc0aUY4L3VKWkt2ZEhBb0hSdGJmdHFSRy8zVE0yalhnZ2lwMjN4R0NVMnhp?=
 =?utf-8?B?dzZObnI0MVlRUHhnOGxpbVdwTmFqamlmckNBU1FIK0U5UjhZRVk4SDRtR1NS?=
 =?utf-8?B?Wm5LMEg1ZEJ6TG1YYnEwSkJUT2dRUitBczZLN2RCa05lb1JPVEF4dWFyUyt4?=
 =?utf-8?B?UmFZQ0xCcEFucFFGMzlXcVBncnhJbWZLWnk0ZnBpakVLU1IzZ0V6RjdtYXZl?=
 =?utf-8?B?VlE2ZzFiN29hVmNGVS9BYm12R1pCMmY4M3RBTXdKNVhwVkJjZG5hSHpaMEh0?=
 =?utf-8?B?OU5kS1FwNktZNFJKdmhRWUU4Y0FtVlNJMmcrbUk0a2Jsc1lVcUNmWDkzRXl4?=
 =?utf-8?B?eUNEbVdyT2R3MkpKT3drcVArNWRMdzZJTnJBWEVCcGJpWGsrei9JSjVmZjAz?=
 =?utf-8?B?Nlc0SG1nbjRVUUVxRFJ6cHZrTnl4dHBlSFRmSVJQNVBkdlg2TEZZMDBjRWJN?=
 =?utf-8?B?eFo4SFl0ZGtaMGo5NGNRWUZHeXFGSUFyOFFpUDhXU1pyU254RUFERGZkUFZk?=
 =?utf-8?B?K0JFVk1qckV3TnowTUt4OXllRi9XazB2Z2lzQ2cyNkRkWTZSZkJKUVlGdWVB?=
 =?utf-8?Q?seHzgk8Kr1hJ545+pDFS6D6WL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d575d012-ebba-417b-356b-08db9cc6387a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 12:58:56.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnvRZoEMrGNLUasA3PBJ/JRuymm3up9zNA6i5XbBw6Tm8wmx3U5sSOiTb7URIaDnrlIH70vbGMy4VywfRMIJ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 12:33, Paolo Bonzini wrote:
> The VMGEXIT handler has a time-of-check/time-of-use vulnerability; due
> to a double fetch, the guest can exploit a race condition to invoke
> the VMGEXIT handler recursively.  It is extremely difficult to
> reliably win the race ~100 consecutive times in order to cause an
> overflow, and the impact is usually mitigated by CONFIG_VMAP_STACK,
> but it ought to be fixed anyway.
> 
> One way to do so could be to snapshot the whole GHCB, but this is
> relatively expensive.  Instead, because the VMGEXIT handler already
> syncs the GHCB to internal KVM state, this series makes sure that the
> GHCB is not read outside sev_es_sync_from_ghcb().
> 
> Patch 1 adds caching for fields that currently are not snapshotted
> in host memory; patch 2 ensures that the cached fields are always used,
> thus fixing the race.  Finally patch 3 removes some local variables
> that are prone to incorrect use, to avoid reintroducing the race in
> other places.
> 
> Please review!

Sorry, just got back from vacation... I'll review this as soon as I can.

Thanks,
Tom

> 
> Paolo
> 
> Paolo Bonzini (3):
>    KVM: SEV: snapshot the GHCB before accessing it
>    KVM: SEV: only access GHCB fields once
>    KVM: SEV: remove ghcb variable declarations
> 
>   arch/x86/kvm/svm/sev.c | 124 ++++++++++++++++++++---------------------
>   arch/x86/kvm/svm/svm.h |  26 +++++++++
>   2 files changed, 87 insertions(+), 63 deletions(-)
> 
