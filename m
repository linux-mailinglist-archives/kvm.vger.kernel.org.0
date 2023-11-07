Return-Path: <kvm+bounces-1032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFB147E4671
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F9711C20948
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81528328BC;
	Tue,  7 Nov 2023 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="av89pqQJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779D82FE30
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:56:53 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2068.outbound.protection.outlook.com [40.107.6.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FCC93;
	Tue,  7 Nov 2023 08:56:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKIvE/88eMF33A2hcdVLUS9ZdOoa7aru2rXPMjn6cq00Xrz6p13zeZUhMBKD0TCjsX8YDuo51z9swfXlGTm+RCNUtChMJgi2kmFv1MRgJ7o8yegFiPWMhOEYGh3K9VAxJfKuPNFdo+HKFyU3urwV8GjKiF9wqFmNxVtv5xdQ/Hmu0yJ6msEzJ/jdu2+8Rj144KO5ZFymssQap+EcLw8wCh5l7n+dn4EvbJUFtDAUYe1FT8Gc6UgwQAKSZXgIGE40B2q5j6kxXszYBjm6QudsnrslQ3eOqSBJPyNEE/2JldyyNqjRDcBLTEeNJF0iOZ3cesieT4mMLxHKHRRdw8bSvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZClyEyDdhZakolIwM4cgRkTXRGtOzgPu9JZjdr/7eI=;
 b=J+IfUkxBWhvO6/Imcdn3BisPKwZeXIVpwRH25AONW1pA2h3JVlbGPo6DHCmovL3EWgDA7Y+4kJDsbGhiAK63JIZ0pnKXHSu+sJS/kwdyp/KVjhqOzFRIYHUvJ9TmF09rY2UdgUS4PLQ5l1/wzNz7+t7l4tRxL1A9npZ9EY2tP2tbEW5o3UQ5ODKwi2DykVl8dqRhua9IVZgPxjfLcwH1CFtRKy4qH9xBupscpJiw3egJUeCTzKd9AIyQDO0tg6wtCyxXRrE72D0QgC9K5iDhlwG65SyNqvlQHB8kW36Ugml+wYLZqmhYW820eG8vCntrkZMZnXY/lvZVxvDz4UHgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZClyEyDdhZakolIwM4cgRkTXRGtOzgPu9JZjdr/7eI=;
 b=av89pqQJCxJ4s/cJ0YLZDFpM/2AgSzf2mHkbpBk+OMOin5oWdGRwhDm6mDg1JQ0idKkNh/e6LNf92LGW29nwhbPfwf+WJou09rXs4DABRe4RBx2tFzRE8J8smSFhyPoWqVPvdGa9y9Qv2G1Dg3fBs4XPiGglGopblD5fmV7BbZdrNFCbZW2xFiMemeKZJFKEl+EguMy1W7mxJ+boHc9zo0EOKSAswPSbQRBqgZsW20Tg6zhRrCQUr6sLXaC9zlQ9HjKMgzFx4QmrM3A2lKsiGdauCHEGvgmjLnf3z/id86+ZiHwkklwyo6HXrMfxqwXm79+8GR9G+/N5Gj9WSbAmfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AS8PR04MB7768.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.17; Tue, 7 Nov
 2023 16:56:50 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::e665:a062:c68b:dd17]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::e665:a062:c68b:dd17%3]) with mapi id 15.20.6977.017; Tue, 7 Nov 2023
 16:56:49 +0000
Message-ID: <047df9f2-ce20-4d76-8d23-20de399c4c21@suse.com>
Date: Tue, 7 Nov 2023 18:56:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 000/116] KVM TDX basic feature support
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0209.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:6a::26) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AS8PR04MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 75f508d7-48de-434a-7a0c-08dbdfb288ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1QEdptNDagvSlZXne0SL34iD+Qs5CRhpJHqzEbHCBA9pS3p2YV9DbX6i2nTmtdxNPAGbQmQHfooF2wxvJG3MDj1xacqgElc2WxBYx+vEvDE+01fK/zDvjvbK1m7v5pM0ZnTKCZ9TlHGGzcDKx9mBCWXjRyTVfToFkiO9K+veo9SJqBbcU6CQgzmrD9kgvA3yAZbstBKPlTHRXL3ch3ReYnvbJ4FNwF2ZP874DaOb3RHHdImvp0DjKAEivfgWlj+SBwqPOQQ5Qf/DgoZrUq1XYFvi3ehC0jS42ExtnDNmOUEsKHFxSf6vXEfxiaAt+UnZg/SABWVMt+9ny2mDqxFeyI0YSAaQyLfULSH5T5i3XmOOc7aj1E0N6Wg2LdqDK9ztX+2uipq0QOi0X3JrQzEjxPfvHNNDWPR1GXXQKT3lBoPxJXSWcNIt5qcQ5TTUvRHpvcE3zT3JDWuvbU59TF1llu5s3obdbJW079d8tJEs9Qfa502CeprbAeImQ8iR6sOF032fyCiAPbJ+d1g9zXn3kHNegOZzXj4GwF6EuyimymR0gmz2PAD0aZvnZ1srvH7aCeQcct9L6xnhTmbk3Uxmt6YOgoMiKO6LnqZlrWREoL3rtFf+lEpbt57AAhrJolzZBmhdv/4hMZ5NY/AZLJzP3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(39860400002)(136003)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(2616005)(6512007)(86362001)(478600001)(6486002)(558084003)(5660300002)(8676002)(4326008)(36756003)(8936002)(31696002)(41300700001)(7416002)(2906002)(66556008)(66476007)(54906003)(66946007)(316002)(6506007)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RE5iMWkrRVpXamI5SzJCRWFOMWJlMmIzemlETC9jTmFGMm00RVB3V0s4dzZz?=
 =?utf-8?B?ZGpNeGtoY1ExOUtVN3hDWDlyWnMwanNLa0lFa2J0ZGg0MTNqZUlZQmkrcGVj?=
 =?utf-8?B?NnpPM2VvMlpDaDJ4ekVOa0xyd0VBQUcwUWp4b3ZZZDVQSmZ5bEdqb2lyQW5p?=
 =?utf-8?B?NTMrdlpvcHJVTjJoRmFWKzd3NkExY2VBZUNhTDE2TlErMTRqYkFhK0lUcHJF?=
 =?utf-8?B?amVUT2hKbzQxdThkSWNtaDdMYlZmSTdySG1zc2QweURjYnVSMnQ4VnJWWEZS?=
 =?utf-8?B?cUxPOFhpdzZFeU5aUkZtTHlRZjVmZ1RlZnBFNUI2eE9DcnVVTTJBYUV3SDlV?=
 =?utf-8?B?blRHRHRSZVNybXpyTWZQMHM5ZGN5bExBdGJLRzZDSmUzeWxDUUNWaUFBRmFz?=
 =?utf-8?B?Skw1WXJiRFFqdWNQV1A3cS85cGxhbUZTL2ZLbnFuVWtMQTg5dVhuQ0JoVU01?=
 =?utf-8?B?dXJzM2tDWVkzZHRYaFptcHdBcFA1VXliUTNiOWsyd0xxYWxnQitEaUtiQ2Zw?=
 =?utf-8?B?a0p6TUoyTEEzNTA2NjFYbmJ1RWZrZ1gzYUp4d1dSWDlTK0I0WjJaQkxzK1Az?=
 =?utf-8?B?U2IyeVd6YlhFWFhsZG53Slh6SXJ6OWtHSnFtaUdKM3BDWjFxNkNHeUZ1TjRv?=
 =?utf-8?B?VDFWUWJDSmVxUHB5R2xrV080TWFZQTdoOXE4Q3ZRNWNDL0ZxNmZvYkt0UEMr?=
 =?utf-8?B?TGMzNzNjTDVMQzBlcXVYTVVlYlZEUEJaTWZJbEZEMXRHWmtHY3ByZWZaYVRq?=
 =?utf-8?B?MmRTWGJxTVhJM0VwZHc3YmV6T3c3MVdKR3JHZXdJYlRKU1ZVZkVXTS91WlEr?=
 =?utf-8?B?U1o0QmdjK0g2WTd5OTE2NXk4MFdjUVRRK2paWi8yY1BhREJseGx3bzFOeS9m?=
 =?utf-8?B?T2tmbXVMbVZTYWE5aEtCVkMwN2lmbUkrVWZDVWQ2S3V3UzExMTRsU000RVRC?=
 =?utf-8?B?SS93ZjFGRHoxVUtNcFlvSEJuQnV3L3g3QWpZbWdCK2tNd1pBNVIzbmErMll4?=
 =?utf-8?B?VXhIU1hRV3RRNUZ6M3UzakJ3UkVUdVdzblRvNlpWeVNIVTlndnI5bUg1UEc1?=
 =?utf-8?B?bFAvNG05d1NXdmwzc0Y3R3NWYmVpR1N3aHdpWEdNK3N2UEZXalZkQTRUUS9P?=
 =?utf-8?B?K01xK2o0TzFNaVVwVVY1K0xmekhoVGMzcHo2S2VMSlI3alVWRE8rdnhGaEFC?=
 =?utf-8?B?RTNTR3JvbHN2UHpJNFVFZS9iNStwdmRPSXF2eTRyTjlKRlBhdlpmSGtlczFG?=
 =?utf-8?B?U3NSNkpFUzRzdWJNdVAvb0Z2ZWNkandkWXF6NmNpbjN2MXlKL1BnK25nVS83?=
 =?utf-8?B?QjlDYzY5aVRkNXRHSXROMFJhdnlGSS9XQ0VUakFSVmhvcWhQN1REdGJLc1pp?=
 =?utf-8?B?LzlUMkJtNkU0d1lMbi9DWVRLNWZSaTBFb0tiWGx0aGVQeFV4U1RzL3lXSFhF?=
 =?utf-8?B?S2UvcVNJOUhGWlpwYXFyUFFsV0xYbk9WUzFrNVBLZ3VJbGdaMHFZVFJZcWx0?=
 =?utf-8?B?d1YwUWhlRy9kNWZ2QU1RYmQzRXlJbDRiaHgvVi9vM0xWaHRGOVg0VGFpakJX?=
 =?utf-8?B?QUJ2d1dpaEw3TWdIS1ZCeHpaN2lOUVpRZ2xuLzEvV0FINUFCandlNkpCT3pB?=
 =?utf-8?B?cXZhVi8veDNYNG1VQUJXTXVQY3ZCV2Z4NWEvMUpIRWRjaWNIVUdVZ1VRVitS?=
 =?utf-8?B?K0VlQVBWZmlhYlk1bnNtVGdlbUF1a0pMcDN2L3MzbUFQRDIvaERlNHVNSXZY?=
 =?utf-8?B?cVEwb1hmYis2cks4TEQvalExTVhrK3doTlB6L283V3hCMHRJSWlqQzIwMmlY?=
 =?utf-8?B?OU55cDZVWExCcUxOT0NXZU1TM3NJQXdIYVNUeXFZRUFWUmxiVG1vWkNGVHZs?=
 =?utf-8?B?ZXl5RFcrM3IzVTk2ckN3bEQyTlhZQmpPNGNpdittdHAzcGVPNWtXRFBGalhW?=
 =?utf-8?B?MVZBaVM5d0wzRHZxNDJBMi9JTC8wWjNKQjFnRG9Jb1dZbHpqWWpUdmZnUkVs?=
 =?utf-8?B?aGhoV3VWcUR1VDlqaTBIR2dqT2s5SGIwSGZWU1VaeVUwUGIydVhVZ1pPS3VP?=
 =?utf-8?B?NjY0NFNkSlloeGhxV3VUNnlSeDFleFNEZFlLQjh4OHdmdyt6bWM0Z05RNGxP?=
 =?utf-8?B?UzBkcUNjSFpnYkFWQ1pqS3VCQ2pQbU9Qb09SdEZOLzRsSGd2U1MzVGlBek5z?=
 =?utf-8?Q?Tcjj6pIK7uG+iUUMpm3TwDn7nAGVbzy5oSNq4O/pg9zY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f508d7-48de-434a-7a0c-08dbdfb288ce
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 16:56:49.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6K418eAB3DuIYcwNwfu80jsFSKYxHQnyMOgqxh2ISPaqGuO9B7g3eACCY9W4HWjaj/3J2MOryUxHtkqdbODbYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7768



On 7.11.23 г. 16:55 ч., isaku.yamahata@intel.com wrote:
> - Switched to TDX module 1.5. Unsupport TDX module 1.0

Oh wow, so 1.0 got deprecated/b0rked even before TDX got an official 
release :)

