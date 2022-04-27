Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C4E510F97
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 05:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357531AbiD0Djj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 23:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiD0Dji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 23:39:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFBD326CD
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 20:36:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvLRZAj2DC3LBKQQiAKOnZwuZ6p0rc1atUdsoxt6khr8QjNT2hK3U2ujdPGLVZ9sXtZJorfu6cxMuc3msUvS3rTM603Js0tZyj6OKoHAp2A+zHHtqe3Kf4/rGXGU0JurSELONzHdjxitfwpn2hxDPztAMfms2a+dujaTaf+kuOp0ck9WYcZJhDWNP1L16k1bAw2KanLREoXsr9GtnxacieLiq1ZmeRUFdYXG4EuvAOCGOg1e93BkTJENLVmS9STS9hGKyvVnVa8IkQLkxCFkHiezkzUUzJy2sVo2bycG3h76xjyuKpNbBNmEyeHfNvNs/SUJD5OtB93XgR/6HChi9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKADN0pUYrNFPuwDnEN32cMnOw6XnaT9U+/mDwUdCdQ=;
 b=OURv0EnfmI4dkODhOCuyd4i6cYFQfBddJxTJtLw2Gb3+gg6tgRiu5DdRqwU8qi0sBinRIbbnYCAEDWe40DY5gZjXZvyeM7vrO83cVpDnpl1+Zcc+Rb8Psd/dQOSE+ZEY5lqVPGJDPzGrmX5UwiNQg7podsQV09wUFde5C9lku/aaNwbINFVPi9NeL0mVfBc//Jc8CnqJ5JszPkyds0HySqR3JOFkNnFHsG2kjUgYjykvyxJkWAIu6IahTnb07aTC814ls+nXIr6fQ51tYCkHlFz5d9Lb11jTLRzc3FEY7gzjnPBqQ5wNdvhGmRvMM8rLbxBufQD27XDh8lBneHm56Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKADN0pUYrNFPuwDnEN32cMnOw6XnaT9U+/mDwUdCdQ=;
 b=z6CdGBZGa9vIuM6AmHQCI6mvAveMyDyf6DeZdCVbNwoZWX3W/FBz9c6QSW9xgwBJCEj5BcSTwAclPTOfsBK48jfcwUoSu+cVjRZ9a6OZteRQgt654ZUC4oK6xyv+duVHovoCXcbPTtWtNI+cX4AnFUQszXHa+S5zq84LCSbZDQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by CY4PR12MB1688.namprd12.prod.outlook.com (2603:10b6:910:8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 27 Apr
 2022 03:36:18 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::89c9:4f14:5136:2067]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::89c9:4f14:5136:2067%7]) with mapi id 15.20.5206.012; Wed, 27 Apr 2022
 03:36:18 +0000
Message-ID: <c1d823d9-561e-af91-e622-021afa37cfb0@amd.com>
Date:   Wed, 27 Apr 2022 09:06:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests RESEND PATCH v3 8/8] x86: nSVM: Correct
 indentation for svm_tests.c part-2
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Manali Shukla <manali.shukla@amd.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220425114417.151540-1-manali.shukla@amd.com>
 <20220425114417.151540-9-manali.shukla@amd.com>
 <d87652a4-660b-ce49-005c-adfda0537d29@redhat.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <d87652a4-660b-ce49-005c-adfda0537d29@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1PR01CA0160.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::30) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a416c987-0c9a-4bf1-ded0-08da27ff16b6
X-MS-TrafficTypeDiagnostic: CY4PR12MB1688:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB16884DECD422F8838DFE3203FDFA9@CY4PR12MB1688.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ue5NJEj54jj6lTC0XWxzn+JI3sffbHTDt8oLKh5IM8SetxEadLPwVvy2nG1lz0XxkfYp5xiRcuRrYqAlOxS7xcDnfHTUUX+m7ouP6sLrkbAupfhxPhil10HKSVlMRyuDHp4bJXeVjNCNvSoAKE0ekVB7WUGDt9AK2qBA3NER57Fwn5LJ3J2MYR7s9tsHu7kbegfohSToduNnwhz4JIOqUgcAxk0Hen5TQBNX/iQrtR1BGyM5YXwbP0Ue8gsjKBRwF8JPkR7CMnKJYC1ddsXTF0aEjzIdC2I0SCFUz6cuOphUPoy2uVUfIWGtROZgb8F/NnMIaka7P8ejZNY9eGVfT5XQ+0615BbgM9olP8p92eWk/gFmoVWU9Hls9QBi+l9TvZve1XfOE6pIxIKS56nj3wBTq6h+K7JTQV4y4jN0UH0avOCA4oJnOiOhwhOL0zqRVmn9BBv8bWhJPNFErn1Z+UmMc89lb90NCX7wu0ql7uIySDAv+UxoT4+Lj4G2D9/dCeHpaVQJs13siAZYbOgFHxVd+YGiQuRgRFMOmQp7ETL/yhAnycfcDd5GfOJttGI9xizugZXoB+FhlyJIBw3qQRx7rMiqsTSvsoCHtb24Hr3w/euEMmQClzQgU65sgf81EZn6BsVIei1RcEavGhE9Ru9nkY5/qsnuKO84WCBC/vUjbWAq1PGJ5LKg/PY61wW7OXSnNjOEe5mmjUNmvfIW9Jak4nfNo7Y3IRILTiP9hGxnAL3BLZ0tHsxVxgca03rC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(2906002)(6486002)(8676002)(31696002)(8936002)(5660300002)(38100700002)(31686004)(4744005)(6666004)(66476007)(508600001)(66556008)(4326008)(66946007)(186003)(2616005)(316002)(36756003)(6512007)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3hmS1FuMUJsTWIyZkovNGxjMElZRlBWSTVWVVI3UWhrZElWQkx1OWhWUkU4?=
 =?utf-8?B?VmFKeWNVaWg2WmUzVmNjZHVMZVhKbkd3MUc2ZTNrcDBYZ01CNGhUTnJSZDNv?=
 =?utf-8?B?TUVlZWloNFNUUCs2R3JqdWdWWlk5QmdlcnkxMGVObEp6akFkdlNCT25kU0RF?=
 =?utf-8?B?MGxDcG5FWkhrcTdtNDRhT3crYW05c1ZEYkxYbXVBVDlXaHdlangyMm1rTHVI?=
 =?utf-8?B?cE0rbzdFeE5TalB2eXJrSmFmQkErY3ZMNVEvUW5XSCsyRkZZTXdYZWo4dWNW?=
 =?utf-8?B?YTV1TVoxVFZsUmhkd0RzOGRnVmJjNmQyWnBNOFpYR1FrU2JhSDMzQ0xpMWpZ?=
 =?utf-8?B?bzEzQkovdmZBa205Y3Izd2lIeVpMVnhzMlJaMEladlRVWmZlTDVEeXIzV2Iw?=
 =?utf-8?B?Ri9YRXJSY28vekZjODNzVDEwU29TVnNMM2IyUUxCVjRVc1dab2UvbUU5d2ZH?=
 =?utf-8?B?Z2MxN3hFZVA1NzdrNkxXZkc4aFpOYS9MWG1DOWNTOE9ldzJmNmdzNjNLQldl?=
 =?utf-8?B?UjdPTzJWekZMcnhFTnAxYmVPbVR0YzlYWG5OY29mRnlLV3A4Tkp2N05KcnNC?=
 =?utf-8?B?MWY3NGxiT2hTY2lDMXhYM25NWU42TStOaDVsYzRVSTkrVTRrc2VGdmxsY3hr?=
 =?utf-8?B?dU12M01uVUVselA0cnNmYUlpSnJOaSszeTBPelYrRTZmSHgwSnBhZWtzVDNO?=
 =?utf-8?B?TTRsTFFXL25VTDQzMGdDTjVmQ2VNSWZnQnI5T2MwR1NuWHc1UDdLMm9JTHpn?=
 =?utf-8?B?RjBXYzVncmRHZkh2cGgxb3BzLzY3NlNjd1VESm5QTG0zZmxUbXpiS1NaV2NL?=
 =?utf-8?B?enVheHRZWFBqM0Y2RGcrQWs4TzB5YlVXU0FzSnNjVW9VT2hHTGloRE5vZHc2?=
 =?utf-8?B?ZllkT2gvRnVSdlN3SEFTWXBWNElGcDA4VUE3VGd1UFpjYnFFVUN2OVNSWEFy?=
 =?utf-8?B?SXdwUDdXOEtoRUl3Nnh3Ym1DZ0RGVXgwUWZFZUtKUVNTTHhoT0NvUHBSbnlX?=
 =?utf-8?B?SDdaRGhwT2J0cGFZWW9FNEJaNWtpR0pKS2xEaGdCamN5bkZJZk1UaGo4c3lu?=
 =?utf-8?B?M1Z5enpMQ2FwRFhnVHYxbTRZT1hnTEJtb1MvcC9mYnRVSXNYampaeTNyZEl3?=
 =?utf-8?B?Q0ZEWWNySkJzNlVabDA5MnJtd2hXWFhQSnVxR05nazZVZ3hhcTFiS3dqQjFo?=
 =?utf-8?B?VlBldWg4S3BvZXNSZ2pZd3BnY0lobS9tZklkVnE4Y0JvNWs4T0swSGtYMjkz?=
 =?utf-8?B?RjVGNjNjM1BDSkR3czF1SkEvR0hjSFJpZjRCR3ZUdDltS3V5Yk50bnZkL3dl?=
 =?utf-8?B?NjdhUGVuUFFTdkg1RDB4ZzFOQ2JGSXVSYXR2T2NsUGEwaVJjUUdUWHJHSy8v?=
 =?utf-8?B?c1p6a3FKME5kWi95aE8yazkrWmNvakRLS2dVbWlEMjByRmhwQjZZYzFXUEZ4?=
 =?utf-8?B?TmRMT0tNTUNTSVJGYUdldU84NW8zR3dLUXhsSUZ0SHpqZU9LbG9HcHF1dVhY?=
 =?utf-8?B?VlcvSkQwbjBFcFZTbk9aaHZzbDUraVBSZE9JMGxLNGFDNXRER2ZwR3VHem91?=
 =?utf-8?B?Qk9pK09oblRhWU4yRytHUjM5L3p4cWFLM3ZYcDg5am85bHhSakk4andJUGl5?=
 =?utf-8?B?K0VTWVpEQUtmazBOREpDYi84eFhCQm1COWF3UUVGVGNrK0N0NFhQWSsyUFpm?=
 =?utf-8?B?NWU1ZmgrMHR4aFlTcGtmaVRaV09pUWFBZ01NcUdXRm9rOU81dHZjZmluRUl1?=
 =?utf-8?B?YmpmUkpIZXRiK2lJT0ZuR1pjYUNVNTIxRS9iRDBlWDlrbG9xeTdPWGtTL1Rz?=
 =?utf-8?B?OUo1eTFKa1FrR2x5d1ZxQkJLS2wwMmRmV3lWVXVENVBkN3RmZ1Y1QjFQNFhw?=
 =?utf-8?B?c3FTUFRTK0pLUGdnZCtiaGZrN29HamtpZ3F6RTJQZXppLzVkYlFPK1k5dnNt?=
 =?utf-8?B?V3dDL2IzUzV6cG5lNDJvNWVNeGp0cVZ5cXJwSW4xdkdIS1k5N245andkWlJ4?=
 =?utf-8?B?bVg0RWdHNWt4T0ZEMjQ3bTJQOVJoL1pVdGp1RkRVZnhGaDFBMFhwSGd5RjFy?=
 =?utf-8?B?b045Z09kTGxVckkyeVFOV0g3cWExRXRrUzFwNFY3R1ZWenlYMVdoa3F0b2NK?=
 =?utf-8?B?YWY1c3JGaU5CckFJeFBIV09vSEI2dXNMdzNsQlcrMHNTajFEdTMwcHpPZWk2?=
 =?utf-8?B?Z1pSME94bjZmR3J0MUNsSWxBeFdOU3FtUjUvTGpOR3p4cDdZb0pLTDhiK1JO?=
 =?utf-8?B?ckFjVTRSbEs1N1gwUHlEa3lqY1d6WVQ2MFlCcGVWd3ArTGxSUFovSm9hYzZG?=
 =?utf-8?B?cVk1dy85b0FneHpoZDlhdlh5YmVWKzFtTkhHWlE0SmkxVTczVUFMNlE0NDdZ?=
 =?utf-8?Q?PG8pTnDKLb94nrnisHP/aLn9+YnhI7iPeWUtEjSLDjDoM?=
X-MS-Exchange-AntiSpam-MessageData-1: cg8rcugdvUGohg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a416c987-0c9a-4bf1-ded0-08da27ff16b6
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 03:36:18.1791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IrTiXufwJKyC1jGY/CegJnX2RnhfdZyvwoQCD4agDQP90uR8ZsimygsnJ2o6/O5Zpdk+XYDewlAhp1PJBsWsVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1688
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/25/2022 6:59 PM, Paolo Bonzini wrote:
> On 4/25/22 13:44, Manali Shukla wrote:
>> +            if (r->rip == (u64) & vmrun_rip) {
> 
> This reindentation is wrong (several instances below).
> 
> Paolo
> 

Thanks for the review, Paolo.
I will try to correct indentations on required instances and send the series again

Manali
