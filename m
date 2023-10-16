Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA227CAE67
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjJPQBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJPQBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:01:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7661183
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:01:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GCdP9h007847;
        Mon, 16 Oct 2023 16:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=KltHQAmD3uV+Wwr65B92hOcqeH/kTe1OsUYAr82qZCw=;
 b=kjCcTmjCTabnzaZ09oSAKS8p1r/AIl8CWmEcg+sZ9u1BkcFpb386XAc6LNqhsJiV4b2V
 BepYh1JcYCzMnNXR7hLu3YjzTSXzEtm5tcTbla53bwIemGooOaHQJOJEpG3Efc0sVOK6
 PwuHxOtIPxacdWqpPbyUy2wlrPv7V5nBwA65eapbnirR8221S0tbbf+Q2nY1KGf3Qffc
 63hSdBWmDzDDoZLMAMfLnuZ127w2YDVQHRZnx1/domBShN0VWZLa7VK1GN/nasYAY4fK
 D6s0ufX6fhHmY1OkpuL/97QCun1ZOPWmsn/2AiUd23VRazeSf7jccdHDBzZMgJ3hkuSo ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1b4k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 16:00:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GF9OXa021602;
        Mon, 16 Oct 2023 16:00:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg4ysvmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 16:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8b1NxqBpFDJcvA8Wxx4oof2OzXA6cGS4FDHT3yShFd91at8BunJx5il7tqVGn5kz87WYbKcf4ZRx/kSsPBsDJFTweBOjJEue2Ko1rtMDETqQ4lKo5pNc45k7EtSn6fSeDRzC5IRgTnCenI5B2iNsnoz/OuuZMWMHjsjqSFWpKoRCjCdrO0j/FHVSbwnTTWQ8fFFmO3li0MH+pWeXVWT6LNYpSfCFe8pJFMrfTqNIjivsLN1glM9Npgd1RDvZ5Ll0Xmu5YdS+VyBA7JV0aGo70enfrsxKqWZVLEQmiEq01sGOV5OSAH61jrY2GRUyj2RECAUvlQmCFy1iqwo4+sAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KltHQAmD3uV+Wwr65B92hOcqeH/kTe1OsUYAr82qZCw=;
 b=h4IHy61k7en08i0Mf7+rs8J648O4IfBCZlBfNI969nlrz4wSNkqjX/pRNVymZJG1db/BW5mxXMxDjVzwqgwwFoArmrS/Y9lQk4j06/1PyPQEHS6GkohZJFv7Gs7VPMjPSFh05GdmhyIlSjvYKlZWhNsLJwNLr6YkOXKOeyIGvzPX8LgZhUdk70w+T5qTsgocUofGUJ1xx30QwACsO16ZoN7WNNwY5mGA8B78kSjNflFBzKxEqc3DHUf2uOswCrOT3CzUwkoe1Vljjk8OcKR6zLSb3SxIBl9NW1kOY5jjf+pNkclqpT1VWv+8klNdi/l1bIH7Mo/p+nEEWrVEZonNiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KltHQAmD3uV+Wwr65B92hOcqeH/kTe1OsUYAr82qZCw=;
 b=bCyweC6TFAVkjh2U7IqEwlJqLmSJCVII3ecGva/AvbenWNABAylP7LsDWcguU0nh5pDHsfYTe1pB3eBgnzpFWL+wGbZa0v/E/G+xXN9vkuaOKmiCV1aeUYY0Aeyh9g+uPnREfn/Z+ZhfE7AfFUVk48Df1gJ8qVPVkKDUC/C1wOc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB6074.namprd10.prod.outlook.com (2603:10b6:208:3ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 16:00:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 16:00:38 +0000
Message-ID: <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
Date:   Mon, 16 Oct 2023 17:00:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
In-Reply-To: <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0069.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: ccc39c97-7e05-4ec9-f421-08dbce610a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIWbW8qTM9BLQRErd/h0TB5cse/T6zVLpohDbRCpqrPwM6N6hd8Wd0VOWtzpmiLbjIjF5IwVr1pfqE+2zERS3zvP9wvSw/KA1Hp5ORYFV4cpnCSrvLQGVTTn9qokJP6yoKZwqWEXeNjBPp2B4d0UHKcxavmD7hMYa5EMu7dFwKHzGHMwX8ajpyfEmnDgxMSXIbCN8l5+OpJhJjo+ggMUGpY95+FZdBvl36vQZEFZc1lIwoYlny/KxG+hwGO7RCS7RZWBEs41Lxlh7vVdTgJOTDXCIUIpgVxnb9WkS7PcAfQHhwueE2Mk9ldA4Pn/di7ejrgLqLMPCBqFOnLy0eWJEfjEs6JnWtrkugOKOsautD9PGd/nN0Z2OIwbjICosUH3H2qLkYQwzcETGH9OK5hBpkGUMeOoKfk7CFj5yVNt1ElBv690RDNeV7ngkX88wSiyCCPulg8UpWfeUIuLcxCnUxDDjwcIl4215fGdVs5CW3NYOTC+oHWrNIfDFfCBXB1lMYcjhujIRV/W8CUZEPpz+OqxKnMMkI4eXwzp/kKgqCGhFCDgUn7CWhNp/qPB0sGwW52UuemhItpBuC1KEyS+gBVPAco2+o5oTFrlHNSXMCbzC8+jOrdzv/tzeJcn/8SFURA7FPQZe7x8E+eWvgFO6nz7uYN+KEc3hYvpuvzgNJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(346002)(366004)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(6506007)(53546011)(5660300002)(6666004)(2906002)(26005)(36756003)(2616005)(83380400001)(38100700002)(86362001)(31696002)(6512007)(7416002)(6486002)(478600001)(54906003)(66946007)(66476007)(66556008)(41300700001)(316002)(8676002)(8936002)(4326008)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDl1WWd2cW82ZDAwMnNVYXV1MTlLa2wrd0hGU1pHVUV2SytlWTcyUktVbjNi?=
 =?utf-8?B?TGZ4aEwwV2dZdHRkSExnTGxIVVZWNnJzMkRvQmhaay9ieHNaYTJySCtHYU1z?=
 =?utf-8?B?VFA3TjNJUU52K0V1MFJVVXJBSXkxYUN2aDNvdllodlYyTXovZ2wwMEUwb2ky?=
 =?utf-8?B?UXhybHpvMGVVUWtxdjNCaFJhcVNXZjZLcVpmV1FYemJBMEZhZEVJTUEyMmtu?=
 =?utf-8?B?bjFQVnlRQXVRN1pRZXVSbCtUZ2pHQ2hZNWxWZ3U2dFE5NVBpQ1p2bWVQZkZW?=
 =?utf-8?B?VzNSVXYwRHdpYkZGaExlNVd1ejlHMHdvNmtZM2luQnptMFhNejFoRkk2d200?=
 =?utf-8?B?d0MwVit3Vy9iWE9hc3dUUDRrckNQcGdxTC9iYVAxbFdVRnNjWnNkZlhkQ0hX?=
 =?utf-8?B?ZWd1QlJrZVBWaXo2c1hyK3hlbkRQUjBEalNjZE9wVW1BNUF4MnNOR0ZnUERu?=
 =?utf-8?B?Mjl5b0xBVTFhcG1JaFAwZklLcXlHM3h5dDVlc2IxS0ZYSTZBNHRIcFVwdjlw?=
 =?utf-8?B?MGJkUkF3aDZtdksxU0JVUnJVYm9Mc3N3VVRpemN5am5VVUREK0pKY2Foa05S?=
 =?utf-8?B?QlQyaDNLZUszaXRnQzBMb2RDTEZTOGFrVHdaYlFXNGMySkFPQ21DSC8xUkFT?=
 =?utf-8?B?b0FwRklmbTFaNHVjNTJ5cnRPT05nLzlZSmt2SU5UN1ZxM05GcjFKVVdUUDF4?=
 =?utf-8?B?VEFqMkRlSTdqSlJSUlFrY0pNVWxKcWZNNDZ3MVVZQXZqUGk1RThRcnpjZGhn?=
 =?utf-8?B?NE9QTGVuZmhtbzBjL3RSd1h0Qlo1cWpjWE85ZC9OSlZXd1dRY2gxOEN2RDFh?=
 =?utf-8?B?N0JJZUZZdGo0aTZ3T0F3RUlCNlloR0kvcmZGN1o1d015UnFsQ09ab0gwRE1C?=
 =?utf-8?B?eW5GZjRvenFTOHJDaWhpVk9zVTAwbnBLNXV1emdFeUVrajhlcjRLYm83WlJo?=
 =?utf-8?B?RVdyVVBjUDRhUlM1N0puTXliSHExMFEwc3ZOclpRVDVadHhram43NXdvaDVC?=
 =?utf-8?B?c2oyY2Y2TG1HMVpwU2Iyd2owRmlzMXRMNjh6YU5xaTQ1V0pUWmM5bnlWdU5F?=
 =?utf-8?B?TXBvZzY3bG80NWZUQkp1blV2SUFJY1I1TkFOMDhpaXk2aXZnSkh5aC9BOHBz?=
 =?utf-8?B?TkR0Z2xiWXA2SWtLWFFTdGpLUENNN0xsRk92SXZGTkNjd1puNXZMYWMwSjJj?=
 =?utf-8?B?S3UzZ2YyZXZaOHRTRUsrNG4vbnY4QVRKM1Z2eUVaSUM0T1ZoYjd1bXVzNG9h?=
 =?utf-8?B?Uml2bWFWK2pjUmJGWHVqcnBSWnhpRERkU3k1ZlBBMVl4aEZncUJkOThQcVE1?=
 =?utf-8?B?NHZ3M0tpUEVjQWhLUlBnc2Q0Wk5sZGtneW4zQ0JITDd5WVc2UXBIa0ZJUUUr?=
 =?utf-8?B?cWgvNTJuODYwQVlBQUp4b0VxMzN0V09lY1htRERNVHYrNXlFalN3ZzJNd3lV?=
 =?utf-8?B?TER6V1hVVVY5R21PSGw4aGZkYThmMnVobGpQQklLa2JjVlFIdnFtSElPSDgz?=
 =?utf-8?B?Vm5RcjcyOWIxb0tFcktCN2Q0QW5lVmk2L3NCRWJmSUkzR0hCazZmNnkwdWVB?=
 =?utf-8?B?ZEtTRFdjUGhHTkZXVDdvRENGSW9FZkYybDNuc1Z3YUU1UENXdnVuOHdqOW9n?=
 =?utf-8?B?RjR2cFlWSStVS3g0MithNit6d0NQQ2pOUThSOElYOWxwUnF6dGxkY1FSeEtX?=
 =?utf-8?B?VzdGd0pVd1lBa2N2NSszaTVHK204SFpZeUUwMDd5N1FkRWJ2WHZjdFhhU2Fv?=
 =?utf-8?B?bmh3NlYyTDVFWVNKTGJGOEZnY3ZoZVBzSTUvbGZ5QURFcXhHa2tEeHovTzFC?=
 =?utf-8?B?WmZrZzM2dXhmV1grd1h5UDdiSFJlSmI0UkEzUzdJYWNNQktQNVZBWEMrYjB3?=
 =?utf-8?B?ZFNJNGlobGtmTTNvSmk3Z2RmRGRrWmt5bGhXYTgrM1AwQnlHcU5HYWFSN2lU?=
 =?utf-8?B?WTFEbFNlZDc2UFBJRkJ2SXBLamJKUGZhK0ZnYXlvV2dVL3BETXNPbWtXYVZl?=
 =?utf-8?B?VHFVVTRKRVNoU0pkWDZPWFVkV294Nng4Q0NqaWJEcmlzRHBBZFhPYyt6a3lR?=
 =?utf-8?B?a0xYZ214QlRlcjZ2T1BMalV0SlhMVWVCLzZBYUM3Z283QnBxa3hoUHh2VS8v?=
 =?utf-8?B?UWI0R01WMjdBTzZHdEprRk1BR3BVZ2JKRkVIa1pDMXNrbS9DdUpyQW1BT2hx?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZFRoWE5RTWVLQ2JVUEJoK0xpU3pTQ3F4MmJHclc4ek5QS1FNbWpGTHNVMGdL?=
 =?utf-8?B?ZWxVUG9HbjU4RndyR3dSZm1JTmZLWHR4ME5QRFByc091NklwaThtZ1BLVE5u?=
 =?utf-8?B?OG5ydTlpTEdxQ0JHV0RldGhGVlZtUC9RZTFkODNpRUpCcGlGYzduT1lVcGQ0?=
 =?utf-8?B?b3I5bWJJc3Z6RENoeE9EQ29LWWZXUnhTcmJSYWNxbHJ5aVpKQjFOOGxFMm01?=
 =?utf-8?B?ak53WnhrUUdiTU1IdEZOMDZ6eTQvL0drZkk5U3lueGhmTjRaOTU2Z0RQTnBH?=
 =?utf-8?B?NHB5OUlGc0s2MW95SmxFM1hmRzNxWks5NjdLUnUzZFlyeHJTRzZQOVQ1ZkFO?=
 =?utf-8?B?NHRRYlliZjNLZjVTNlViQ3NuMEVUeUtuN0lXMUNHQ3FYRStUYXhLeWpvTWYz?=
 =?utf-8?B?bGJHUlpLT09Ha3Y3Y0lXSVBZTlFhVUtCSUFrMTNFTldscEFCUkY1MUtsVEFM?=
 =?utf-8?B?YjZwOVBrYWY4N0lienNiYnZoS3Z3SkJ0NTRDK1FIRG9CalZsaXVZT2h3VWNU?=
 =?utf-8?B?SDFGSCtYbERvYjh0c0d1NVhBLy9tSDU2dFUzbWlGSHlHejc4LzJhNVk0NTNn?=
 =?utf-8?B?RzhRakp0UEI2OXlqaE9MOHBWWDdvbWpNcUN5ZlV2Z2RyTDRPQnF5c3J6aUZO?=
 =?utf-8?B?RGs5WVBldWRKcFFKSFBQaTN0YkV5WFBTaTVJY2hHTi9XRy9qeFQwMTduSTlw?=
 =?utf-8?B?c1NMM200Z2g2Q2ZBdGxLRktROWExU2pqNVFQSlRmSVFqRXppQnVBb3NUUlF2?=
 =?utf-8?B?bmN6a2MvNXFPMUJiSms2Vk5nWFM3UEtzS25pNk9ZNGYxZUN2c0VySWVRTmcv?=
 =?utf-8?B?L0pDZ1lkOGFiSTlIYUVlTEl0bU9NeFpUS0IrQzVxTVpFZG1OYy9jbHBLMmw4?=
 =?utf-8?B?VWdLcm5RekNHWkh6RHgrTzQ2NVp2c0ZsTGV0Njh6WFlmd0w2RjVpN1Nrd1Jq?=
 =?utf-8?B?Wm14Rk8xbnNaTGVmRHJHc1Y0MkVmeGZaeVZwa0diSG9VQVV3U1pTU0k0OStn?=
 =?utf-8?B?ZG11UTlpd3lZWW44SGQ5S2NuV3dSSHVWb1JnT3pxMFhWcGZEZmJCTmJjcGlp?=
 =?utf-8?B?VHhoSmdYTnJReUVaSU96Ni95MlVUWENaa3djZHA5UHF3WnpFWjFuU2FvUjkz?=
 =?utf-8?B?aXpGS29oR3B5cVo3Z2FwNFZ6NVhDQXlWUWVHNlRTTVR4ejZoajBKOFhzSDlH?=
 =?utf-8?B?YmlkR0tndkdYMmRUQzJ3dkkwVUdobFBhczVYbDBQR1BTWGRFLzN2bnBBTG16?=
 =?utf-8?B?enpuMHhGOG1MNnpVSWk0Mkd3TDBZV2xJSkZKRG16V1VISjhEV1lYK3RkNzhD?=
 =?utf-8?B?TUxaM1hFeHNCWjVGRWlIRlFNRUs1QWNUUFJtYXBJb0pXNkNEVTVHWDZnaC8w?=
 =?utf-8?B?d0pzVEI2aWdrZ0lOeE5uQ1dvZUthcFhsNTNTR292amg0OU9mVnQzajJCdVBi?=
 =?utf-8?Q?9TucOerO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc39c97-7e05-4ec9-f421-08dbce610a1f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 16:00:38.3299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDiG6fYjn+QVPNeLZmMjdDy5amD0WtwuKixFdfePfhWH1aM6f4s9JLGQ0iu1z11fGuIEMziJ/H471WBjigvn5so1pkG5SqTdwasmcurT3qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160139
X-Proofpoint-GUID: 5FR52-XLWit725g0p8Qt91WxFqEGZZuz
X-Proofpoint-ORIG-GUID: 5FR52-XLWit725g0p8Qt91WxFqEGZZuz
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 12:26, Joao Martins wrote:
> On 16/10/2023 03:07, Baolu Lu wrote:
>> On 9/23/23 9:25 AM, Joao Martins wrote:
>>> +
>>> +    if (!ad_enabled && dirty->bitmap)
>>> +        return -EINVAL;
>>
>> I don't understand above check of "dirty->bitmap". Isn't it always
>> invalid to call this if dirty tracking is not enabled on the domain?
>>
> It is spurious (...)
> 

I take this back;

>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>> need to understand it and check its member anyway.
>>
> 
> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
> already makes those checks in case there's no iova_bitmap to set bits to.
> 

This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
essentially not record anything in the iova bitmap and just clear the dirty bits
from the IOPTEs, all when dirty tracking is technically disabled. This is done
internally only when starting dirty tracking, and thus to ensure that we cleanup
all dirty bits before we enable dirty tracking to have a consistent snapshot as
opposed to inheriting dirties from the past.

Some alternative ways to do this: 1) via the iommu_dirty_bitmap structure, where
I add one field which if true then iommufd core is able to call into iommu
driver on a "clear IOPTE" manner or 2)  via the ::flags ... the thing is that
::flags values is UAPI, so it feels weird to use these flags for internal purposes.

	Joao
