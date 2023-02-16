Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46699699E6F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBPU6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBPU6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:58:20 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54D84D606;
        Thu, 16 Feb 2023 12:58:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgJtwBS4iVYHp8o0kwfx0K98Q329sTy85CqdRM1jaiO5MfooKaYuXnPkhWVBN8GztdBTw3ZwfZicuYUXAOGqWYyJfkTVmgWAlcB0uGWw8OJJ3iKTKthwF5n6Wf2xUOt2I8PpIefbKtThYH0gJorUHO8yVPSyCvOBekATlnJus6IhwV+vGUzIhVygynI8vjA7hxxwXF59u9ta2c/CTPXtxqhQnqChFSzex/jiAovLQFZ8CnYvtIAV4FfN5c6Vhe9RteAO8xHUJSYoQsMPsZkxiEqz0I90B/gBekEfHbSzEQq+dG44vi/Py1UoTAO3bfhJU5KhBUj7laGsEuhSMF/OPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8CD/H7+wiyrJpNZLzSFerY6qwM0hmZC+d1wtPhnF9E=;
 b=F0GM2vi4O0hbGaynLIUjrULc05DUuLIG2L3VfAUDdVf0KWE6NqiCwY0K7h20KwNsL1/MDbKaCQJyLNnn+1uWvZ5Q9PYcP9lVS+Ki6JqtqnnOAtrLGLdlelD7mzXQAk0HpXdAZpow0j78AkixQbzQ+f5XtFsYLXJj8NuO0/NNhMCswUTNmpDhhYvS97yBqwkyLH73u1StKgMD6U5b4MrLxJyn4X5Od1Kcm3NSCc7toUH9VbG9P3rNwbz7Ul57xgvpOe/s5eoYDRoJKA+uIEW0SlaAaQsgNamV2EgXB1uKS5eb/jcZCueIxXG/c5MAjQuUv7XTRfnI22KSYDOwrxgN8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8CD/H7+wiyrJpNZLzSFerY6qwM0hmZC+d1wtPhnF9E=;
 b=cf0Qr8BChsn84KwxWdvrrWw4rYxkIwg8+ExfELzV24EpBJ6eC+YJdGChg3wz86HD5SVUSo+F+Rq7MZ2OA1L1US81/+VC6XMps1OjnEs9r8ily6sDRkW6+sKawaESlXEog1wg4pUlnKi7Ntwug2hBB3eFtXoGkLM3/X5KcvoVYOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 DS0PR12MB8525.namprd12.prod.outlook.com (2603:10b6:8:159::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Thu, 16 Feb 2023 20:58:16 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba%8]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 20:58:16 +0000
Message-ID: <cc106460-01b5-abfb-8856-6d65ee7bb866@amd.com>
Date:   Thu, 16 Feb 2023 14:58:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v9 1/8] x86/apic/x2apic: Allow CPU cluster_mask to be
 populated in parallel
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        tglx@linutronix.de
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <20230215145425.420125-2-usama.arif@bytedance.com>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <20230215145425.420125-2-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0287.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::22) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|DS0PR12MB8525:EE_
X-MS-Office365-Filtering-Correlation-Id: dabdce10-9f46-481d-2a86-08db10608666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHR3EQclULYPq2fYgJnlicL9rs+7XwEmvWEMn3FTSj67Le1IdB37BCDKBLqXt4b51k5TRKkkFAq2IpFUQyI+ti4UrXoA5Pf2hcROKMG/otlDhnOzHEdP9Hrokjr25t/6r+OxN3ZLFltkrexJeUSGQyisgclmJ8le+FKWIy++dvu+zpUz7Z6lxbEZyPW/AZZsINaZoFDJeRdP6wkggUTtF/SL/73XtA4qxei6EIkWAHuQNWiBOaqRzLlVEb9v9pCIpYyd1FYCdLh6BNzzckwSoeFwlNO7qzbyQ4Z21n8MBwsEfRk++L63XUYScd7DnDnmXw1v33cTYFnYPanCsWjbGOEByK01150ALmIoXOe89dF+7rShy7bUHnONUdsfu9/kdKlkRabGP7NW+LDKPDXa5hZ6IUS2gCq/DsgPnZQw6uZoPgKB84htBya9GZtKpFKprHZjMjBOokoEZy/SV3hvaIIGYsWUBrldEK6CtaBfUCWCao6bqDsnSJ45Ym/gcls9k5eVn+91wJXgFmdwxn4gtJ4RBRuHDsOVUnT8H9BjxUb5QNr99RqDDiDpY7ioixDaz7qrvue8h3Y2fhOpSMPVbmESkplbkiCjL0H9Yr4x6mMKH1I+VXGXZxUY24Nr2yodg0Lg6KK6Y3Jgyj+MNcqhICDPSemkufvuC5MWiowblN/Z4RWjOR2Ogv1ASRidck29msytMxopiNDpChszzej0rsYsxwrgX9ztNX0dt5KVVIs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199018)(8936002)(41300700001)(5660300002)(44832011)(4744005)(7416002)(36756003)(2906002)(478600001)(36916002)(66946007)(4326008)(66556008)(8676002)(316002)(66476007)(6666004)(6486002)(38100700002)(31686004)(186003)(2616005)(53546011)(6506007)(86362001)(31696002)(6512007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm80WFl4N3ZXUkdGQTJQSlR1WXZuMDRhQzk2ZWN4R0haeDcwQW9lczR6bEFE?=
 =?utf-8?B?a1hlRXV3ZVR6MXB2eDh2cUY2NWMzc0ZnS1NwL3JTc3A3L0ZlTVFlR3V1RVAy?=
 =?utf-8?B?OEZTd0lVNS81RlBiblhCcitVODJGRHB5aVo0UFNrcDRrWG5lR08xL2NCQ0Rr?=
 =?utf-8?B?UVpvR1pTeUF1Nk50eGVEQkFDcTZxYnNjU1RJYzdQL2t6N3d5ckNmM2x4Y1c4?=
 =?utf-8?B?bmZrdFd1ZDN4bjRJcXJxb1dCeTZHdU15bCs4eVVhQkhVelplZ3ZWVHZsQWFy?=
 =?utf-8?B?NFVoWGVEYmtEUHVoT3p3R25Wc0ZJb09FNkVNMk9vK0RTMkc0V00zK3ZHTVZW?=
 =?utf-8?B?c0NrbWFWVHVuMEpZR2R2T3BkR00xWUNvTHNINUtpQUdnNUU4UTVBQXl1UjJp?=
 =?utf-8?B?dHFVS25CbjY1OXhkSFBqTEJWek11YnlUbnAzRnRoamxxbEJPTXN5ZUh5M1BV?=
 =?utf-8?B?VEJNcE1GUVByS1NsR3V4Y1g2OFFadW5MM1hHbUhacmxGVHlpZThJZ3p0TjhU?=
 =?utf-8?B?LzJwSjBZUjJCNE1BTzlWNkdsb0gvQ2UvN1ppaGdxR0NPOE05eGJlMnVsNUsr?=
 =?utf-8?B?aHkyam10R3c5Y09Na2tjelZTYko1TGQwNWZtWEtsMEVRN3VLOFpvSzlXTkln?=
 =?utf-8?B?bFp5OXVWRUFUbTFzR1p0Y0s2OG9ZcWVwZDB3OWtVczcrRWpMejZIalI5Q1pZ?=
 =?utf-8?B?YXk3QmNwejFsUzNGWG9Md2ZFOXJtUDFGL29kV1JxZE0rOStMT29YNmVaWnZo?=
 =?utf-8?B?L3dEKzZ0MDlYMHNnUVNNNzdxblNONHBLblErMTZlR0lXREhsVTdiTFd1cEVh?=
 =?utf-8?B?eDZIVjdVcnd5eEVnNllrbHl5WkhOMVlYWGY0STEzdHNsQS9pcEdFZ2JhdzE2?=
 =?utf-8?B?ZUtYRHJmdUE4Vm5xR25GOUlCRTdxQzc0aVd4U0IzbUwzYjVnbVcxT0ZWTVRI?=
 =?utf-8?B?WHF5UVBCdHpTQXJtamxmNHZ2SGZBbDdnZjJVVTQ0WTQydXF5ZWpGSWVRVFkz?=
 =?utf-8?B?a1RkQnI0MnpNNEptVVRDTTdpOU1mQXh5eTVwNGRWWkQ0UC9XNVdtaUdXS2Fo?=
 =?utf-8?B?U29BSmlSclNBdVIvOG4zU25laXFNWWxnZHdPQ2xPR2dNZXFOWkJYcW45U0hm?=
 =?utf-8?B?bEUzdTVRYkZWdkYwaGExRnNncEluSjRLZVZJc0pYMWVBU2JIQzR4K1hFWGho?=
 =?utf-8?B?Q1hqaldWSnRoMHlqa3d1aWkwVmtwTWRueFNsTm9NK0V5Smg3QllYd2N4OHRr?=
 =?utf-8?B?TEVBcmsydElJclF4UXQwKzZ4THRKc2N2a2xEV2xweXpDbUtiVFJsVWRiOFhh?=
 =?utf-8?B?MS9YK3pxUnV5a0dzeG93bE9mdkhJQ2oxV2cyRmtvUmcwS0RBeDhwWlhmYnB1?=
 =?utf-8?B?NGhoZzBmcjhzbEt6SXltZXN4R1A1QUllUWo1bDRJYzRacjNYakovazc3YnEr?=
 =?utf-8?B?dS9NMng5ai9tajM4TlJEY0tSb3k1MitkeFpkcDRKOXVZalV2dDZpU1dlNzlL?=
 =?utf-8?B?S093V285bXEvbEZNZ3pwNlNzdnhyUGFaNkw5NTdkL2tKWks5S2czNzBrK3lI?=
 =?utf-8?B?dGpnR1JLb1NESVNvcGNxNlgwNjJjd1BFV2R4dUFsZHI4OW9PbWZMK1ZZaTRh?=
 =?utf-8?B?RnhjV2QyYnB3RmVxUmdtcWVMUXZ3NUx4L0VEMGltcGkwZzNDenZGMzE4RlE2?=
 =?utf-8?B?OTYwaGM2N3owZ0FRMmNXVWw5OFZmRWtrSWpTdjNnaFU1VE1hbHpUa3g0dkh1?=
 =?utf-8?B?SlYvNWZKdTkyOWNTU2lmdmlOcm5ENHc4VEljRmJpeWQwUmdHWmllMUY0RWF6?=
 =?utf-8?B?V3BqNUhNTE1PaC95Z3QzWGt5cENwR0JJOURXc29TNnpXVmR5TkhwcElGVzVU?=
 =?utf-8?B?aUFyVExpZkxzOTF2a05rRkxFMFdqRFhjbXcrazdHTU5LNEhxd2V6WktxYzll?=
 =?utf-8?B?SUVhOFFPVEZoVXVJaGYvTm55YS9sRnlSMGV5eG5tWThoMjhkMmpQakdHeFFj?=
 =?utf-8?B?VWtLVFNZUW9rTzZxUmg0T1ZQdnJYREVCdC9xa0JZcTVVeHk5eHhaZFQvK2ND?=
 =?utf-8?B?Q1Vxb1phNUM0dmhFL2ZTZ0ZER2NubHlnZUZhR284Yk0wV0VCdTVlMEJSSmlH?=
 =?utf-8?B?cjJldy91YW8xWHZISFhGdDYxSkZDRzRxa1UrblJGU1RIODFVaWs3Q3ZyOW9F?=
 =?utf-8?Q?1gJKd02MEmT74KFC1aSXqxcsoYz8bIS3jDJZ61iOM8hh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabdce10-9f46-481d-2a86-08db10608666
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 20:58:16.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0HVcrLYvhY4RlVsNB1C2HLNI2xUm5XplK+QUWcGJWPq8w/Q89xRJZWTgcx/PIASAjfP1T5BdLIRHFhb3dNoUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8525
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/23 8:54 AM, Usama Arif wrote:
> -
> -	cluster_hotplug_mask = kzalloc_node(sizeof(*cluster_hotplug_mask),
> -					    GFP_KERNEL, node);
> -	if (!cluster_hotplug_mask)
> -		return -ENOMEM;
> -	cluster_hotplug_mask->node = node;
> -	return 0;
> +	/*
> +	 * No CPU in the cluster has ever been initialized, so fall through to
> +	 * the boot time code which will also populate the cluster mask for any
> +	 * other CPU in the cluster which is (now) present.
> +	 */
> + alloc:
> +	cmsk = kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
> +	if (!cmsk)
> + 		return -ENOMEM;

.git/rebase-apply/patch:167: space before tab in indent.
  		return -ENOMEM;

> +	per_cpu(cluster_masks, cpu) = cmsk;
> +	prefill_clustermask(cmsk, cpu, cluster);
> +
> + 	return 0;

.git/rebase-apply/patch:171: space before tab in indent.
  	return 0;
warning: 2 lines add whitespace errors.

Other than that:

Tested-by: Kim Phillips <kim.phillips@amd.com>

Thanks,

Kim
