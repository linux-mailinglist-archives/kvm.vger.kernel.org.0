Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EE0633448
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 05:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiKVEA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 23:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKVEAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 23:00:51 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FCF2317C
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 20:00:49 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM1WZbv018057;
        Mon, 21 Nov 2022 20:00:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=z54Kz1vvfWFijnNoy3RrbbIiIlj0l0UMQ3lcWDfL3tQ=;
 b=1pwTgpRXikUm6+vFMZohmfJbIVs5uvo+cT9wrhl5Fp90hFJaiI8OW6hidQJB92cH3kaC
 niQKaCrEdczm72KetjyfRdn5LYPxsiMMxBtITBF1btxkBoRAJrT2YIu45Vkaqk40KZNO
 swclN1Q39u54NogGj9Vev2aflaKEPVAqtV4uw+DfONfQoul+/J97Yu+ry0RHTy2aUc+K
 mm3IDbUSz2T+4HWbnbA3JaoqHPL5BHfImfTwcHrC0eaEEuCq36f14CTKeVNJDKbxRmXr
 4/3VaAUc/NutgmZbjFTRWipvWN8/MyMJzsU5IJBaYJGgQl2TsUofrbBqaOSE0KeMt+GB Pw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3kxuxcph35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 20:00:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7wHHp9I3tpwH6ve21g+h1cdGzLHCm0nsDTM0PYI7oLOlUIwwCK0TrJOIof/LWULRBQ/eh3GrpT2QTi21coISSqopEfcekbB1EIJegekjGOiT6Qu8RFqSMtCmwYk/S3QPlMD/5cM41xrTcVx7w9NUd3puaP/WYMKsqEhj4kls7oRTnk6N/VXm6XH7BIKdU+Y1V4JzYLJwUerSHRTByhXSa94tX6oUDm7P+S+V62jJFNnlD/kAgaDJNwi6OLKD4+MKAeFoc4LiRgaLpc9PBiJRj9QcWJ5ZroRqljP0ym2EKzAuGx1w1HbbMM5UEDEDccwa/3l94J0KwDJz43IGD5+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z54Kz1vvfWFijnNoy3RrbbIiIlj0l0UMQ3lcWDfL3tQ=;
 b=XdoLcVfGs7yYmDWd3UeYSvh1GfK0uFEYwWPMs3s1jRTTT/63+BMIebIPrR+KKsuyeESfgW2hSYG0hqGOlNTfuxj8qBrGHPpCjSFIC1++r4gsdGiyfbLIlGr2tusgVAjpg6lOcZB4+n/+sTEG3X7XFbAINFXRdm6SuKd4BzknXupxI2Qh9qoH3kHFIwxUL90pLs/y2AN3NMAQBSX7ijtpFekWUmdzohAPy5jKjNhWyWeiXyOCSlOUW+LXAGmcS9jooO5psA41NRJzshqwwC2wIv5HGRyShlw/D/8OO/k/eBk321vZRvN503y4oYhYdMMtZZGe2qHUfMrfv+uCoIsKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z54Kz1vvfWFijnNoy3RrbbIiIlj0l0UMQ3lcWDfL3tQ=;
 b=U3KzObYs/mGfI/nlKtEGVVly+ngzn1PpBMvw8G+DfZ2nJe8OlhUOUDzxS1ayUhOOfhz91SrBLcBF8nROOdtoHBdjOKN8kqf8WfYZs7sX0G5+TRHN592lYtTFDU+0oYpEOZj1vM2qkWuCU7MX5xgCInz7kSpc0erjHNZQiA+k8CgRspI1MIGOVDJalNVOQY4NkbaKUxVYLT+oG2eQ/6UIQ6VSEiMMeynqaOxTjAKP1n+M9oKKRSOm2slX0+H4ySogbJ1c3lLdBcoAMHu4pczI+kPWqmsbLFPD+2bGMejQB8Qm1cG45TGZlW+OtBq+MmeG8RPvPF1X9+fEFQIu+x8FSw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA1PR02MB8510.namprd02.prod.outlook.com (2603:10b6:806:1f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 04:00:35 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 04:00:35 +0000
Message-ID: <8cf78246-d00d-dbab-7e67-0ba09300e6ed@nutanix.com>
Date:   Tue, 22 Nov 2022 09:30:14 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 1/1] Dirty quota-based throttling of vcpus
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
 <20221120225458.144802-2-shivam.kumar1@nutanix.com>
 <dcaf828f-5959-e49e-a854-632814772cc1@linaro.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <dcaf828f-5959-e49e-a854-632814772cc1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::17) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA1PR02MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: 2140eb82-fd14-429c-a31f-08dacc3e1b4b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qg+SOHfyZUh/TtbGyLtkTAMBShnfP/jv1RJU954Z4tvKMARul52OeFbV/jjpHOtWU5vHeHHxaTefl//xtkWsmrF6QgBnsSOdZByz7vdBcY80nokOAsAgU784Tao5u3OGg1pqu2JzWlyKmUR5fkt3XoQCrYy6akJ4za9ssqTmO9XQ07RYHVjhAMzqYG96/BZUlPPcipxKSzZIfLqfGWNFquJhJl9/P0yI4lgf9YL+iHHyFMBCo2vc2M9n3yJpG6W3CCk8rVWGHJ3sl9bueu8ISlmsXLzO5pNGZnQkQKruH9rkPy0AIQ59MdIHCcHmwoCO0SVIPTXauiClPGYX1unTO8jyol73xErPj0mSarh7btYLfuCESibUVRW+hmV+3+ONrMb7kOcRe/Ml8CD+VtqCu52Fsx0ABd0HH2kyIdKgE3ckQkTFfnE6RsmSb3GCiUlrfUsBVxfVnrcmYLYSdJKwyp3jyoUkknHAr2F8EMZNqHFmZdm+oyciZXsIYBGs3aO3k3XlNpojNZMrG/TazRrmcvvSlZZX3Od05W6wIxo3nK5XwWZ/neqBAfO+tdauK47I66hgYKXEywCa2YNm0vVc8aiCYa7NoplBace9S7cboWuZff0+9YCpg8Cp8gcv0vaMbl+fJQoIKxOIWZrDVQ3Y3pfuSjU6DkMvtpeGWq3tG/x7BoUUL9pTp5bMAIdMgF/WZO9EKUz+QeePsTk6v1UhFJ1Yle8q2AW4cjULLStHOemtfWY7fMpT3RTZefw/YxAw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199015)(2906002)(83380400001)(316002)(4744005)(66556008)(6512007)(5660300002)(8936002)(66946007)(186003)(36756003)(41300700001)(66476007)(2616005)(8676002)(38100700002)(86362001)(4326008)(31696002)(6486002)(6506007)(107886003)(31686004)(478600001)(6666004)(54906003)(53546011)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnAzL3pBMWJ0dTBuSElmdFR2Y3BkUStibnF4QmZqWGwyUm5RamdHbE1BYjVW?=
 =?utf-8?B?czluZkFNTzFMeHJ2UUN1M1M1NWxldk4vWjZKNVZFaXVIakxwblE1N0dQeERS?=
 =?utf-8?B?MzJlK3kxOXBQaThZdTZadG5SSithS083d3h4Q1JMZWhwdG1yOC84R01NL3pO?=
 =?utf-8?B?UDlWODZmUk1yZnA0SkRWam9EMlpQUTA4TnhKYXkwMGNiOUVpUHdnYzF4dmtx?=
 =?utf-8?B?V3RCVlFsUlU1Wk03UStub1dQTnB1YmxiNjZ1a3pzZENzK2ZLMUhDbHIybTBX?=
 =?utf-8?B?emlpTGJSdEZob3pvSUJnVFdnTk1SZUs3ei9GT0poRkZaUU93VGo5QWVZV3dT?=
 =?utf-8?B?WU00dXcxeW5mMDgvZjJsbGt3U0dnN2hFWG04dUNkeGpZZU1YWlFVUm9hQlcr?=
 =?utf-8?B?K2pTYU1HYzdGL09SYVo2Sm10b2N0MFRiVWRxRVJ2NG1JcVJzK09kSU9iTk5H?=
 =?utf-8?B?UkYveUNENmFES3lxUytoV0lmK3UySjQwa0dSTTg4Nk5UZWh1NUZwUVE4cTVq?=
 =?utf-8?B?Z2VzL1JCUlpIeld1bjFSak4ybnZDNjhjbUJXdzVKczlxMjdWMjF5cUZaaWN2?=
 =?utf-8?B?Yy9oVXBHUFZsbFV2S1Jvd25obERFQzNVanAzUXorby83Z0VUTTVtL0MyNFBX?=
 =?utf-8?B?elhhTGVJVWVud0wzb2pKWk5OY1QrWlg3eGlnckNqb2dnUnljR3J4ZmRxdDMx?=
 =?utf-8?B?YkFPNUt1NEh1bTRBdGR4akVvbHNvYmZMMEVpb042Ym01b1VRQ3lXMVFNRFVs?=
 =?utf-8?B?N1pqSWFUYzI5dnFHR2Jvakh3MHVuYzdWMzA4bUJ1WnVsMERyZUdsZFhoZDZE?=
 =?utf-8?B?R2lvMXFWaDBJcXBDcy93RGVXd1BpMlIvWWQxN0c2eTduYXFqR29UK21SZ0Vl?=
 =?utf-8?B?aWsvUXY3SmhvYjRvalN3cmhzR1ZQcU1IVjFmeEVtQnBMcnluNWxQZHp2amNa?=
 =?utf-8?B?TC9nS3U2R3gwdlI3SFhtQlRUSzIyejV2cCtPaW9yZXl4bTZkcTQ5K05pL2ZW?=
 =?utf-8?B?c0lVOEM3aXNhWVlXcnZWZ0RnajJaOUJod01RWTBQZVA4MXFYNzBHNmxRT3FY?=
 =?utf-8?B?U2wwNU9oNkVlbWtoL0ZuZHpyRmVock8wY1drd3Q2Wnk2cm5xdFplUk5USXFT?=
 =?utf-8?B?cFBudzBibUczMEVZVVVYUUJSajNtVGJPMGk2WVAzWkVsckpoUDB3cFM1b0tU?=
 =?utf-8?B?SHNDb1phUXI3d1NsVjF3em11VjkzaVd5WUI0YjhVNnppakNzdU0xKzZLN2xt?=
 =?utf-8?B?MXNiNGcreW5ZRmlTTVl0K3pBMUcwMmpGT01XalN5WmZyRUROekpOYmwzZHlh?=
 =?utf-8?B?T2J6a0gxczVkbnp1ZDhpdW1UcE5ybVFSbkQzdXlMZDJPbGxBMjlidkpFaFVy?=
 =?utf-8?B?MkxIWUUraFl4Y3QvNVY2cnhwcTA1dmNTL2tjZDhyVlJLRHdaMlBwb2VXbUxr?=
 =?utf-8?B?TnBYSnl3ZXlBMHRmNEZzbGRObitKMUFaYW9RTmo0MUtqM0NwTTRueUZHWmM1?=
 =?utf-8?B?WkRDQ3JxdEhkUTNEVkg4RWlqdzN1eDFqaVFiT2w3eUxjdTRZdzZyb1JwRkpj?=
 =?utf-8?B?SUFPSFAzN1pndlY0TWFpcGZGdVVtOWt5VjVlREJndVlsYUFBeXlOd3VoSklN?=
 =?utf-8?B?M3BrcU1CdWFHZTFyYkN5MWswdUxLZnhBcVk5Uy80NmdXZGhDS3FmOEE0eU9M?=
 =?utf-8?B?RkNycER1VW14NnlIbnI0ZDJrQkh1SDFCVTZFczhHVXRFNndyOHlZd3BSR1Ur?=
 =?utf-8?B?U1lSU3RnWVBZTHpRWmx0cnlhSmxrekNIb2p1MGdpRk1MZWVlWmdhRHoyZFY3?=
 =?utf-8?B?Sk9ON1AyZURuNWZQRHQxaTZlUjBVSVg4K3F6L0RSOWY2K0liUkRmb0paampm?=
 =?utf-8?B?WStvYWJjMG81UExweDRaMEpJNjEzY2RqR29hZUtKSEJBTGFkWHYyZTlYeHdM?=
 =?utf-8?B?eVA0RFlWaFhqdmk1a2YyM01yMlRwY2lpL1ZocUJ4OUZPSFlWYjVibFhRdkt3?=
 =?utf-8?B?WGRtUWNkK3kwNWRTMHViUUs3dEJaVzR4MkZRVG9iOXdVYUdtWFlsS3pBazg1?=
 =?utf-8?B?ZHVPRkwwaUFoaXFSVGpZQUEweEU1Vkp3MEtOWFNTWDJPWEpqVEQrZHJWZzU1?=
 =?utf-8?B?Lyt1Q3lLTVZDZEVURkJSc20xSVUvcXQyOEpMcERLYk9iZ1N1Y1NPQmdEU0NY?=
 =?utf-8?B?eVNEWmEzdUlWc2dWUUU3Mm5lYTRnWVhLb1UrOWtVQVhmMlZvVGF0WEcyaENs?=
 =?utf-8?B?bTJma0NpQmt0VGNGWitrRnhVWlhBPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2140eb82-fd14-429c-a31f-08dacc3e1b4b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 04:00:34.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHNdKAlcy3FLjfs9J7PdDaMfrFiTrDQPqCeYA+UWGAp/kJp2XqGaTeeFJ691CpB9WjMI4hThbl7tGb5kUhO8km95cd5ZVFNJkcmdYfWlLME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8510
X-Proofpoint-ORIG-GUID: zSNse2U_BBYgzH0LuiBS0dT9dlRpKYce
X-Proofpoint-GUID: zSNse2U_BBYgzH0LuiBS0dT9dlRpKYce
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_01,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/11/22 5:05 pm, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> On 20/11/22 23:54, Shivam Kumar wrote:
>> +
>> +void dirty_quota_migration_start(void)
>> +{
>> +    if (!kvm_state->dirty_quota_supported) {
> 
> You are accessing an accelerator-specific variable in an 
> accelerator-agnostic file, this doesn't sound correct.
> 
> You might introduce some hooks in AccelClass and implement them in
> accel/kvm/. See for example gdbstub_supported_sstep_flags() and
> kvm_gdbstub_sstep_flags().
>
Ack.

Thanks,
Shivam
