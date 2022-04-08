Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D616B4F9558
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiDHMId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 08:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbiDHMHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 08:07:39 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE6CF9F92;
        Fri,  8 Apr 2022 05:05:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAIl0HcK4yDcb61gkduC0IvL8D0tDq5mcTUrr+x0lhgZOWzZeCNfnU1bTy3fuugQ5DwaX467Wd0W3cIUePgDcIlE6TqWDYTHPEsgkbAJCgfMSBH+K8rTTzCsftxLHd3q5+FEMd61bT86K4HhISN0K2UgF0qTzW1jnqN/1PE1ym7Qqy+3AtDPKIlMDAFgVj60yKrObAIN7WqPl5HU3ZrWPSf8TYVR6HkS/ITwuCdLMtxQwJ6yOS5wi0eeywvOdgABM2MZaOaDwzChEukqvac4kipHtUx/8YzkNf+lhfGp8aefBtHQgmMON1HyiPNe0A19lF+e/Bcavt0U7xphas9QWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bG1QNLccl+2k2aBjos+4dK4oxYCwn/c+URC2oxZBB0=;
 b=deMiw8S5gN87zbWgK4X0MojMHDSegx7MnGsWELWHhVLrJ4heghmdJfL3Ca7PZNQw7VC5gRZF7R1cH/OZ4MmavBE+wRmnaiDvn4hLp7jN283h62X1YWT2W0anvBJhTZh5CWPIgDlDcStYxi7LxygQyeV56nWWmrZ63wzQ+NvRC6dR12Ji1VsAZqx4HUc+CJT2XI5HxPo8W8/QpGK0LoUAvGC5P2+aXr+zb6CHH+DrkukTVtTR5+HZXKp/Jl5iY7hR4U3BbD6ukpnPNNQJNH+5SeZuAlDPUoSbAMLvV57SB3hES0uYUYaJODpDYapcBCkVszJ+Jza9NppSFH+DFPfRew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bG1QNLccl+2k2aBjos+4dK4oxYCwn/c+URC2oxZBB0=;
 b=g9pjE2jx5Ag4VQ9NwJfKCgSwhc+W1IGLR1kJSGbNvZyFcWPAEkgqyjVgmjFNBqRfCcPIQEXfFFn5POEZ1Hbf1OMT8bPVLyWND6OuU8slUqoENCIwfejGs42g4enxJ2ivmtlhGHme8M8Bu8AsF0R0Gs5Vw/1abNSGpxROGVGoBwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 12:04:36 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953%7]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 12:04:36 +0000
Message-ID: <6b5c0dc4-4ccc-88cb-5a9b-c422fd7c9a11@amd.com>
Date:   Fri, 8 Apr 2022 19:04:23 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: SVM: Do not activate AVIC for SEV-enabled guest
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        jon.grimm@amd.com, brijesh.singh@amd.com, thomas.lendacky@amd.com
References: <20220407175510.54264-1-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220407175510.54264-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef212b3f-ac25-4b1f-f381-08da1957f2b0
X-MS-TrafficTypeDiagnostic: MN0PR12MB5836:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB58361245113918B3DF17A3ADF3E99@MN0PR12MB5836.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RefPDZWRoIYMjBUznic6ldk4JV7j0qGM5PuGw2n5I30twTwOwVtaUlfMaIAo5nX8F7M/3h0V3VdqnU1RN6bM9EDusuZlxlLe2YehjefWDUpNi/fUv2QU2/xTrKPWx3JS4jhTOZVLFq32Tl2HT5cv8021gKPb2fUj+/QmPqj8Sh93Jirj4VUMZiByVrhxRCLNXdKzUWzo3LrmZEI+iO1lXwlZt9Wy+3oOSo35jMsSqAifJcuveH9I6U5Nh5m39iGUti0cDxdemQnM3FNtjjPp4zfW1jJrvof9V4YY3AQxWX+7cd9Z67HVtABrmFmvugnkbADvZv7Rv9BG267ACZ11hMLCRcMyDnjXPw20GdAJRIvNMahH9q3OfcHashS/kNhEkjIy2h1z9eQD/nBMSad1kQ8Vgj2IFxBruaiqUgn1yL3kJRzNzdYoEQ0Ii0d/LHf7iLEUAcLANw2E9GujI80zLjuMevnfemBMJpB1fByvUNejISet40LwDVmajBFCwV2srt5Y1j5vr+V0R9EJmzL2oMKyte3ZFplWk1DM90jZmD0BUeQkwKIaSL/TdCYDy7Q36YGDGLROFxM7x8XGQU5rHCosYAczZrW00lulYKTEd1m/uXQ2wBhQSXKjRtjRCtvSUvtQ1qET+kewsZ+kuVyWvvlzIKvt+ry5mdiQzpXjK2hn/MnWkaOWwD+wuiNJC0zg2S7Xz5vlH6FUFDmkLo+r1xj/cah9wXlX/W37+Cmao6A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6506007)(2616005)(31686004)(4326008)(6666004)(66946007)(66556008)(8676002)(66476007)(558084003)(6512007)(2906002)(44832011)(36756003)(38100700002)(6486002)(31696002)(8936002)(5660300002)(316002)(26005)(186003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OG9lVUduT3ltSWFLcW5DWXZPNU04SW56VFRWNDRkRmZwMGs1MGxRamgrVHF0?=
 =?utf-8?B?WkhxMUQ1WWFteVdXOGdVV1hwVWR2YmZxTFNKdmVyRUVobFRPM2hZalMrNHN3?=
 =?utf-8?B?UkJ1am44K0d0cFhBK253Yy9WM3pqUTVWdmJFV0d0M2RuWHRoenQ2Um5ZdVdM?=
 =?utf-8?B?aDlWRjhpODdmNVQveU1xTWhVRUk4WTV0RXBSYm84QXFRY1RpbUgyK2ZKNU5o?=
 =?utf-8?B?cEp4cm4zbys3elNRREhVNS8vdWQzUjJLYUc0Tm8xRFhHMUhJQkliNytRbXBu?=
 =?utf-8?B?QlpkZ01WWDY1NnREWG15N2NOdGpEdWJISkhjdE1iVnN2WGd3NTRjdm1HdU5a?=
 =?utf-8?B?bzRZc3Z4MFkyeTdicjNGdU4xaTJoeWlKQnhuUkdtYjlKSUlueXhEYmd0OXZZ?=
 =?utf-8?B?Q2syTGlPcFErK0p1L0RGZTVkajNuMW1iWkxqRW40UjBjVjFMSHk1L21XQUlh?=
 =?utf-8?B?dXAvcFNwKzIrZFFkSHN6TGdSYzgvK05ZV1VoWDgzeisxM0c0Nkp4aVMyMWNs?=
 =?utf-8?B?TVh3L1VJaWk0V2J4VUpTT3pRV1NLdm1VTFFGdWt2VXhEV3E3TmJLUHlxU2E3?=
 =?utf-8?B?WVRPc3d0OXBXR1dQNjFoQzJIcEpjZFQ0RlJmL2VoODNvTTljakV0OFhvNUhM?=
 =?utf-8?B?K0lzb0QxYW1EcmdxSm53VzRZTHJjMFRlVmFSYkVSN1pxKzhuQU1LOElwYUk3?=
 =?utf-8?B?ZE1SWjZrQUhNQm9HcEtzK283YllyK2xibDVaY3hySEN4di9hNUs3SkoxSTZ5?=
 =?utf-8?B?R0lCN2RmK2x3L201d0Z2UkI4K281aVNUMDJyb1ljdEJjOFdBZ254ay9zV0VX?=
 =?utf-8?B?UWtWYUlQU0dLRzZnbkV6Zm54STRZODdUQzlrOExsekM5Ky9BVzZsZmppbWVq?=
 =?utf-8?B?bjBhai9ZZ1IrY2xKOU5yVjlWcElCOTJGYjBtUGV6VENaQmFjaEVpUDFwdE1F?=
 =?utf-8?B?bzQzQ0wzcEZLZjBEcVFVdEVuSmovSkx0ZnZyYWNwUWtJUktwUFdaMThNZUdI?=
 =?utf-8?B?akJ1d00vWDVSeFZ4N1JwR0NKYXM0OWV4UnNiQWNHRmtsQzRrYkJSb2s1bmJN?=
 =?utf-8?B?ZzZvZnVNRjV1QWxNK0hqTnBibmN3SFErQUxtRkRXTVhDRDgydHNzbFNTNTZs?=
 =?utf-8?B?dkJzQ3VMSkZ3ejIwZjczRWFkUkgrWGcvOUpXTGcwSVppK0VRcDFPcENpaGIz?=
 =?utf-8?B?MWFRSEdya3lwdm95dk02aHZBaDVTMEVkZnE3UHN4UnE4eDlWMzFEQzYvTmhD?=
 =?utf-8?B?WXYvMjJaTUNKQ0xWOGJ2MzJ1bXRGWEU2Y1ZobjlibXZOK2FUTkRFN1B1b0pk?=
 =?utf-8?B?cURCWGtqUUEvUGgwY1dOcThCV28yQXpyQjNIeUV3ajdCajZ1Slg5WFZ5OEdM?=
 =?utf-8?B?MGh2SFFMMDk2QTFKVWdqdmJtbGtZZVZoT1R4VDJLUWRHOVE5SUJydnNjSXh3?=
 =?utf-8?B?QUhkTXIyUzFLQ3ZEc2lJZ0g0Y1RXWkdySzlZK3VaOS9qSkc4cFNBbVVMWHQ2?=
 =?utf-8?B?ZWJpd2gwQU5rSXpCb2J6cmZTUVp5R1FOcU9kblZDUE1raWtOanMwNk12QU9n?=
 =?utf-8?B?bHN3bVA0WFI0RnRnVXJiSUY5WmNkTXVIZVdHcmFiMHV2NTcvYzkwT0lBN2Fn?=
 =?utf-8?B?NTVIRzk0MW5IRmx2SGkyLytDTERkcmo2ZlhKZ1BQanpuV0RXdHk0SUZIeThW?=
 =?utf-8?B?cUFDTS9TSDRhczlrZlVRYWdSRVlncFRBSTBaZnhqYXl4NmcxanFjc1E2V3dn?=
 =?utf-8?B?ekdweW04eUJJalMyTGx2Z0QreXhyM2VwbUtlQTVDWVRYcFk3eW1LekMyRGQw?=
 =?utf-8?B?VEhZUHpzYkNSWEZoQkdFdlRxNks3Y0JqT0FTNjN6c25HSHVtc3M1QlBjc0NU?=
 =?utf-8?B?dS8zNUpYNVJkV01tN2hQd1k5dU5SdkcyUEZ4VXFoYW50MTBUWDY4NHFUWkNQ?=
 =?utf-8?B?c0xIZnFiSmtoMWlpTTI4ZTJVL3dxaVdwS2hna3NzYUt0NmF5b0JoRVNTb21O?=
 =?utf-8?B?ZmUwWDlIS1JaYWZIdGk3dWowK3ZOR1I2SWJFK0hWWWlGTlp1TFlhaXZmVENv?=
 =?utf-8?B?anVidkF3QmR5MU95WDI3Y1ltdFhEbnJYR0RoSW5oSVJ4alhuVVEyTngzN2Nu?=
 =?utf-8?B?N3NCYm84NlB1dEV1VXIzUmgxSFhDV1dOek80L2FVNkVTYjh3WDFWZnN0SkF1?=
 =?utf-8?B?aG0yN2Z3eldmblo3UmxHSEJUL3czcThxZnZuU0dtYUJDRWR6QW9Id0JBL0xD?=
 =?utf-8?B?emJ6S0JUMC91cWlCaWw5byt1VUdqZWNtS2RaMXZNWHl5dWZoVS9jZUp4M0Ft?=
 =?utf-8?B?YXlOaTR5ZWZSSVdYSitRalJtRENqOUhzaGpiMDJyazhwZjh6cnhudz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef212b3f-ac25-4b1f-f381-08da1957f2b0
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:04:36.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8K9StwZp8nj6ykfG0VdNPEoinGgVamFJUUWS8p2Jp1ee8lfKMMbCnZELnkLPJVAiCsbQjOJ/yq6PYPbiVHXxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I need to re-base this patch, and resend v2.

Regards,
Suravee
