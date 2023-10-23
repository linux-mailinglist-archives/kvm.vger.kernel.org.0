Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556FE7D2D35
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 10:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjJWIvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 04:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjJWIvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 04:51:51 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2085.outbound.protection.outlook.com [40.107.21.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E043D68;
        Mon, 23 Oct 2023 01:51:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBAaOpaxk8aWxiUzMydz17xM9BsCPt7Fugnoxx3uZImoNF4utEfCTOQ3LDDxdgcBZmjS0rLp68ssszf6aJ3W1y1wUooN9kgH5UXoOziimy0QbWw/VWIZIMK2F59EY2Amfoan0CoogLzKbGFKqy/AEZoerp8WPY2CY1bALcmgPLWsYuObQGS+6eQY7YCTKZFdSEqR+dLG3bFfmMrkZlGaZeS9HMbNh2IOWV+nhmw5ft9Q8DsX45OQeOscpnSYUAwDWDRD2qwbuilxViUdaxZuq8maWaazUekcd+pp3LFwiY/8g0VPbeQ3MxYgK9FR+0+cKIPK/THd1vOltkspOBxRYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXBscckPulxgVIpjiR+QAHBRU3KjFXWrJXEU5Tl+aQE=;
 b=LsGtzK6W362dZcmISD9uOM+YR9KjPKkbx6jeQ+i4gZbDawV5/E06AQggQILk2Xlv3Tnw14ssTzWiOMcNKFhvd6RgbH8nXGlXa4KXhw/v/nTb+gSy4W0gbIc66XuLLJHdiaej2gmjtJivS4MhC9rKOwg7gb0i0hN/OM1tijMwumWS/Y29jA7rgAx+LCMYP/GzG3gNmsxxxvt5zIqButqDYQfc+IabuJm/Bk6QEMFpkX5LS+6vjYyNxIPuK6DGfuyPZz39sySgp3keU9i5ax+fbxOssVOcW5R0hUzkLQIqDO9P7ws1wgD37SC12xbiS7+P7+S6rKw8OlLuzoU5/MZJNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXBscckPulxgVIpjiR+QAHBRU3KjFXWrJXEU5Tl+aQE=;
 b=BOTDFUahqNG1G4ueWuNl+EIRsOQ3t3AuI/ptKmCFcRnkTV5Nw1kkWWDmmJMiukq6saw+VEi4z/B2ye9izbqsSZOoMfVih/somvkxngiZQo8MW1/XmGJ3rNUpJnnLOzeJkSpg6y4n+PFYsT4BcBLUG5JkC5HngZfFBBzguhjpomTAHioIglrviqNYLexKIcfrEHJBzR9RZaRuNyEEHOijiDPO7i2PTgB7Y5c8nsJZM+cTow//ObJlmFPFI3ntXsUcOEqFcqKjnHFQCgEWNajP6twhO1Q5tE+bU1kLAoRG8hzxUxkdipbVcnJ6N0kWuIy1iFWR9aszw9Qd8yWd9Xylew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PR3PR04MB7355.eurprd04.prod.outlook.com (2603:10a6:102:8f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.11; Mon, 23 Oct
 2023 08:51:45 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6933.011; Mon, 23 Oct 2023
 08:51:44 +0000
Message-ID: <56c57e1a-bb08-4ac8-9d3b-bdc649640cfb@suse.com>
Date:   Mon, 23 Oct 2023 11:51:39 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] x86/bugs: Cleanup mds_user_clear
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-5-cff54096326d@linux.intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20231020-delay-verw-v1-5-cff54096326d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR2P278CA0041.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:47::10) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PR3PR04MB7355:EE_
X-MS-Office365-Filtering-Correlation-Id: dde0f53b-ad9d-4ec3-baa8-08dbd3a548a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LjyTmz8nSrGGlQ0cVKKKXtigjFRMWZyBAiDrbxSiqAoYo4k0uDuy85X0jM1+slWkhBTMRmSNcXBjCjV73EPr/nZO+rsGu7rL4Em+W1sb0+IgnY8Phqqce6N27MrYhOmo3TxuDP7gyCS7ytjqj1cr3rKCSl2hOeeQoUknl/y+6roBR5I4y9+oBd5M+l1hCr2hJjCScOYqivcT2xhVOw1GpBGxO3n67E1OzElRyWyzOvdWMsQmdib4thfh8XNXm0IRnow6iLvenaPuKJ4TW5eZU7vq2IJ6PvnPohdK8RYayV6MEeUohGd4m/gmML5u0k11T4UWxTjcoa2Mf1uOBkulRp89vyU7kDPUR6EGizsGMPf0J9kFRW4yY92ORHCHc3Yq8YEt8o1synb+yl5m6aiz6ydY4uRG5O74NTTUQHD0A46qKDsU+hYlpAqG6+mA7Ev4zMgFC1MAUJccLrMxyo1qadsH7q/njWWgAevymQCOj1484a7KRZbVqvwLtuJW3yUhwrNdXaKm/bmBycnfCc94kPtQVoT9fGN6ZabcxmAbU4x0FA7AtcP8fBkgn1ukY6his5K94zMdprIqqY9qiD4LK1tVQnTBrMTSphTgc0wml4srFVcE3ifUx1R6ST7/seCH2w9gnmmi2eCICbCqBZRoUBTMuTUpc4cPbIQFqTRBP9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(346002)(39860400002)(366004)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(4744005)(2906002)(38100700002)(316002)(66946007)(66556008)(66476007)(54906003)(2616005)(110136005)(478600001)(6506007)(6666004)(6512007)(6486002)(41300700001)(7416002)(36756003)(31696002)(86362001)(5660300002)(8936002)(8676002)(4326008)(921008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmVaaE9MQmVrZmNEZzg2bVBuNG92SU1iS0lTeXl0MlhZczR4S01yeW5ZY2Z1?=
 =?utf-8?B?dnA0UG1NTjVXa3RueFBwSU00RXh3MUxUVE9iK2ZGRk1FY1J6WFNhR1RGbjd5?=
 =?utf-8?B?RUdKYkNQdXY2bWZ0RkV2TUlEMVl5bHhHY21VNzF2MVJxSmx6ZkhXa1JHMGxC?=
 =?utf-8?B?UHgzcXNGV0NYK0pvYlVFVDhYZ3ZnV1cyNTFyQlRzZlpSSkFOUDZkRmJEZUl2?=
 =?utf-8?B?a3QyNTR5TGVzN0xOY1IvL1M1YkhVTnF6aE9GMGVEdVFzY1M3eGRQTnJmQUYr?=
 =?utf-8?B?d2FCSERraVhqM29YbXVnenJ3S1pDRkQ5L2ZjR1ZVU1ZMbUttRGVXZjJ2K1pY?=
 =?utf-8?B?R3ZOUDYxdmhMUmlqcURwbkl3UzBCcGlVdEVrRVhkR3lLcVhUVmdoYmhZK21T?=
 =?utf-8?B?UWhsWU03V1M2L2F6b1R4Z2RNdUZXWFhsWG5jMjJnYW10S0dtUk9vMEtqbVcv?=
 =?utf-8?B?Sm5RaWVoWG5hdXFtV2JGNzVqUFlpbWhLL2Z0MVVLN0NsRWJqWTBNb3pScURi?=
 =?utf-8?B?ZlQvdjI5N0ZlMGxmMmJudjJhaHdoOGZ3SnZTK1RhTzJOL0N6clIrdXNsVEhL?=
 =?utf-8?B?bkFQSFBWWU0yUklEV0lCSTQzZDdYQjJCUzF1enk1eUZYenVGamY4WTd1VHZy?=
 =?utf-8?B?R2tBZVJQeDdEZFl1aHBOYmszU1hGRGY3dDEvWmdPeFNxSWtKOUFIQzNzLzBk?=
 =?utf-8?B?VGVId1Blc1VKV3ZzWG95TEVJMFhpdllCam1oaEV6QXpwdWZreGVONTF4VllQ?=
 =?utf-8?B?LzA0QTFmVlBpaXV5THJPYklzdXZDNm1IT2tYWFBIaEIxb0FnRkcxcVNUNXcw?=
 =?utf-8?B?OVc1Nm40NlRGbU9NdDRkRDgybU8xM0lQcUFVWGZLamlYMkpQeTU4Rnk4c3Jp?=
 =?utf-8?B?R1F0b1JpNk1kOEhRckQyd2I4TEUvVWVtNFhsUEZHUUZ5bzhNVVAyM1IyWE8v?=
 =?utf-8?B?LzMzVjdJSUJOSjYrakVKekRpR0gxY3N2YUozUnRiNGRjRXlZYXRvUjYyODN3?=
 =?utf-8?B?bU1qOFFqZ0NpaU92WWE4NDh3blJaMWR2ZWhZclhHcUx3OCtLM0pHMmVrTG1Q?=
 =?utf-8?B?RDhhY2FYcXl0bDJTbGx3QXZSZFhJZVlLUDhpTlhCOEg3Q1dxY1lKYk8wVXNI?=
 =?utf-8?B?MUVzWDd6cSthcFFkanNyZzMwbzRUaEtqdHQ2aHZCc3NjcFFzb3VYK0hDQTZ5?=
 =?utf-8?B?NVdGdE1nNG53RGRnYXlNWlpiQkdmb2d2Zk9mUWpXNU5nellDQlI4dFMxUklz?=
 =?utf-8?B?dkZSYUlheVk2L2h6RCtPc1F0cUQ2djJCUEZybXFVeTBVWXdkayt4V25lVEN5?=
 =?utf-8?B?b0dmYkVwdSt1SFVMN1BYemxQVGNTYUhsaTJkS2NQR1FEQXpnU2JqOXl5M0pK?=
 =?utf-8?B?LzJrejlibDMvWFFHK2NjeWRHR3hrMStVQklxdlBSc2RXYmR3N2JBSEZZMUk1?=
 =?utf-8?B?UFJOV1VwSFNOcjdya0tlZEhXUFRySFBEdDcvMW5tTmdpSmZmK09FNjVzOWlj?=
 =?utf-8?B?alUwQ0xqLzhBd0JaZklCR2owTHZuaXFmeWd4WG5rakZtMTd2aXR2WWJVempQ?=
 =?utf-8?B?ZDB5c1BHVFk4KzlHNzFlVVZBbm9ueGRPVVpFUjlmU0R3dlc1UElhUmxJSm9N?=
 =?utf-8?B?c2tGeXBkaGFaWVpRNmVkY3k3RlBHc0FvWlZ4MDlreFhxczRRbzhTQWQrTkxE?=
 =?utf-8?B?NHFnZzVxd0xNNUtEaENrTG5IZlhRODlhNVJrT212WHU0Tm1FRWdEUUtIRGF5?=
 =?utf-8?B?Ni9aTTg0VmdtNy91bWovNHdDTXhTd1ZTbU94NkVtandlbTd5NVUwYkRQd1ND?=
 =?utf-8?B?SHZyaEFIK25PV0ZxOXBtMDFSZFFlUU1pRmV4cVN1c29RWHVvbmhkWTMvTmdT?=
 =?utf-8?B?S0JUVnpHT3RBZUVjNUdjcDRmdlc1RjQ4d215RlZuWHMzbDBqdWpZamZ0dCsx?=
 =?utf-8?B?SG1JOHdiWDJkSkJYd09hK05KRUo2SHdxTG9qK2ZXc3ZQRFFwbDB1T2pacDIy?=
 =?utf-8?B?SDUrc0xQQlFzanNqUGhYejlBdGlHUjBwNTBaWElOVGQySDVJa3liQXZob0hK?=
 =?utf-8?B?SW9LbGVvclg4QkdBYThhRWxqbXRIZWVIdEZiV1Q1OU50TTVzcTNMVVhFd2c3?=
 =?utf-8?B?czYyOGZZM0hMTDJRb0JQLzJWZTVzVUtXeFo2bkF2YUhSSWZZaXh0RDMvVXhn?=
 =?utf-8?Q?9sI/CRyIhaQO8RUbfWe68fOrLJwa4Ggdg6l1gXMc5WNb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde0f53b-ad9d-4ec3-baa8-08dbd3a548a6
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 08:51:44.7498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5lkAOfPg4oTvKAyYl15VWYu1zsKteewruo3CuN3E/lt20LvqJRvhRFYgJO19fJIkFcGTPDakut13NCJKVKRvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7355
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.10.23 г. 23:45 ч., Pawan Gupta wrote:
> There are no more users of mds_user_clear static key, remove it.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

This patch can be squashed into the previous one. You've already done 
the bulk of the work to eliminate usage of mds_user_clear there.
