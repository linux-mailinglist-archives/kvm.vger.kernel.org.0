Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B9F4BF780
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 12:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiBVL44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 06:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiBVL4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 06:56:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5934D14F989;
        Tue, 22 Feb 2022 03:56:21 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M9klbt032173;
        Tue, 22 Feb 2022 11:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jg5qCuHetU1JEVxNXJKQE7bU3r4Q+CP4plgmLPw/WiQ=;
 b=zzU2f0EnBUUZZXJ7HISRcGO1c1QFUFBcRXkXBezXfOWCTsDpqwmSXbIcO4yKksWLK0Om
 HQxoUyVlDMu3BOloBih7DlqMoczSOGzWd048x1lTcze8x6lYEZsbv2wH353b9LAaEZB1
 ygrZHygmGGZNEoqE1Tvv25Ww/j2pWuGRKJn1pKb/CgQdeUP46dOFGRpsq+42kDUh08Uk
 HziyRE3bsq04SfFs19yIORdXs+GSxw9KiBxtOOTQA7CYAIGCRqtcKbqGC3uQ3Xfo6pqm
 bQVocl2WYeNdSzDYE4Yc34tWpmg/A6SYDau5TZLfthzNAp98ZSbU/OXxAkm4zu7W5iwg HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ermsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 11:56:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MBodTC054432;
        Tue, 22 Feb 2022 11:56:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3020.oracle.com with ESMTP id 3eat0mrgkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 11:56:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUnRDK1G5+q4L6U7sv/61zcyG24W34HEUkCCm0PK+bFBSSkZ8wmzzbqW32mYxqrRwPJmxP/d9Y03flyfKi+22b8MtYUmGE+O/YbnbruOlpmsBKJiaSBzkDeIUPqjxpHqmM+NtwtBwqHHAum4yIagRsEEnlTkTZr7+qCa8Hea6jqjM8ikUTpwFSSxcDDccGx/5f3BFQ8etQRuWlkRD0p2rSQiGxcryIDg2mb6Fw6fXznJUpSUL8q1RB6/zbOBZIv/CeBFKnTbig+XrPSWQKntHvm6+z3rLoQ0iRilGkAYwW35lgjwOdLbjQA80WHESpUxkXNGrHHoh7tFwxmsVvAp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jg5qCuHetU1JEVxNXJKQE7bU3r4Q+CP4plgmLPw/WiQ=;
 b=Weuh/4QQ+xeTWtPaDGC0XIEzjUBJWLpnPLigeBXxBMun0AvqWyGxZLGnbInT8p+ExT5l2tp8ngxOCe5THjRwLl510KoRlZPVrXY7MCedZbxz4EpUHvLiuDwrbl9vpOXl1Ih53xEYJ4xl7oznsWk9/E4Ue/2f0X3AUZnCWbUtp8vKNi4PJWQXwg/plvV40vT60vlC4wXzTjNh8YuoK/TUwrl5SvQWDF+6gJBHvONFOEC8q43GYSe8E46z4ynoOY6ONSfzjJKrA10DjfXlRVvfRbMdQ05vF4fbSsjv6sAIQsfmOper6L2Xccsh20ZUHjF/C5Hn1Z0JGOiERCNM4gRQpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jg5qCuHetU1JEVxNXJKQE7bU3r4Q+CP4plgmLPw/WiQ=;
 b=Eg5O+tQTh+/WA0EQWaaiLJMML6JHMtm/6moZuQF8r22S/mGLtrn/lmQBqeo847q2AkLD+5w6VSjUPSrR0lGgFSOypK0WWiqe3EIDDeoXihy3NSku/rDGDRo1LQdbrkHw/qGg2yDQf5+sMAaoi0W6xpvs+1WSFGL5DN/SiPycgOw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3484.namprd10.prod.outlook.com (2603:10b6:5:179::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 11:56:03 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.021; Tue, 22 Feb 2022
 11:56:03 +0000
Message-ID: <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
Date:   Tue, 22 Feb 2022 11:55:55 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
Content-Language: en-US
In-Reply-To: <20220215162133.GV4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 140b8564-9e61-4fb3-97d7-08d9f5fa4d1d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3484:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB34847D9878D08B009BE992FBBB3B9@DM6PR10MB3484.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGCJQQ5aR1PnuTcsVZ4aUSf1WgV7brG6gakWqUHAYKAbhhUfPYt5anOlWKjfB2uVdDOjCdAlLiG1Ca6p1+lzzRm27AGXwmEJGG3S8jRF6C1T/SKN3x7MdQgpziuX8n4WnMibUYZOzRMfFS4CaLqdT973gGJ3wvwK+UTV1T2CHzyUB9tM1QEGRntKny//EsS3JmBxhl7ufJxnmhJz/2ypYqBNkc5UKSQn/Fg+N4LKVhyo9dDZUuoQ/oCseTnlmsRykJR0XNrVmURKNIKPVLrE2/NaJC6k9XvBGGECtw4WKi/438oCvCcWr8kdDtzIsx/pfz1RSAuXQLA4bGKPip2g442EYKKC981yINvU+6aR12gRl9C6aczpqpv/rAo4C/4HSO3t4AcBU41wBiajph1rcA19hXt+eD1EdDASglw8tgjpoeglwpSeo0xxGs5OcvcWIdbhRYo63CFuZjsQ3ud37LVSS81LUOsIP+yUUKqQ0EzQOS2bWyxV/XtgWmjDng7ITmMnM2LE53RgJfAkSH8QSgoArOtoVr83HrEhxjqn4IvqvX6Uw2y290fJcXLybikMJ1O/EtHSMF0tRAGmrlKP7N1MDqV/1Vhk5JzXiGsGiT5zdKv6FdSVy0r84t/fgf5oLKnk9WXMxmqlWx56gakgjeBpB5bh+WkrQqtgnYQZj0dHkfYGvWjz3OrOKstEk+rVf/mpoGbGNOiH77U/K0cuag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(38100700002)(6506007)(4326008)(66556008)(8676002)(31686004)(66946007)(36756003)(53546011)(66476007)(6666004)(26005)(6512007)(6486002)(8936002)(508600001)(5660300002)(316002)(7416002)(2616005)(2906002)(54906003)(83380400001)(31696002)(86362001)(6916009)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2ZkSC9ScWpLdmM0RGlTVzU2OWt6dWZiMk93M2tlNG14T2d3Zmp4anZwVmJS?=
 =?utf-8?B?aDFMWGpaTGdUV1diV09abzJubnJJZ1dzSlNqZmdFeWkvVGZtVXhsVHBHZG5U?=
 =?utf-8?B?aFVuUFpvSGZvY2gzc0VuZlp3YS9BT21qSUNkMVV2WStzYjZQa1Uza3hqWEww?=
 =?utf-8?B?RU4yZDZLclV6akFqQklXYkNnTDB5MkY1M1hYWkxDTmhuUnFMWXRibUVpZ2ps?=
 =?utf-8?B?VTduMjZEL1VrWGdEV1lTdEc0Y08yS3kvQ0ZwTHdhUkozS2Fwa3RqMVBtRFEw?=
 =?utf-8?B?YXlneE15ZHQvcXlnQ2d6elNQZ0YvckdmaldsblhoeU90d1dLT0xaM2pTUkJp?=
 =?utf-8?B?ZUFTRkowdndSMi9wOWoxUTZSaXh1cmlkLzVXcHlMTGJnbWxCWlRXUzNZQk5i?=
 =?utf-8?B?bURHMUMxSDZZaE53VzRkSHlEcGVoSjV6UDY3Zy9sS2tUeGYzQ0JQMDZ4MjM2?=
 =?utf-8?B?SFJvd1cwSDJIMDFkck4rL2JhTDV2QlN3eHAyMTJHZHpUdkN1OWRKdjU4SldO?=
 =?utf-8?B?MzlJdmhPYTFuMHBYVnpaNU5hUDBINUsrSkc0NXNHbXovekRMdVdxOHRQcE5y?=
 =?utf-8?B?cmlNazcrUWhzOVdkZ05BMkVMcFY2YnhYV0E4S0FZWEJGYWNxNHMxOHBibnEw?=
 =?utf-8?B?SHRnZXlSUEpoRGdjK09JdjJ6alE1NVJHQjdyYlFoRkZadnNZN212UFR2VW9G?=
 =?utf-8?B?NlZrRXgxRnJFeFdHd0V4bnAxKzNGQWd6WExwdGlIejFEaDV0cjhCQzZKaGlB?=
 =?utf-8?B?L0phdUJYdUJrOGt1WG4xdGxFY1Y0TXp4OVNhRDhvdnNFMnlEY3ZPZGs3Rngw?=
 =?utf-8?B?OWR1SnBCTHBPN1RRVE43YXB2MXRDWlNFbkxBUHpuUUViSEtOYnFIYUp1dEpk?=
 =?utf-8?B?RlZ5djVFdTVWODdESm9PME5GZG9ITUpMS09YMS8rZ0pwaEJkSHVaWnV2Nnpw?=
 =?utf-8?B?M1RKTEJPZ1dvY1FocWNwVTBla1FIa1VRMUF2US90VmpDbzRFdXZXdFZYdDNt?=
 =?utf-8?B?b20ycDVvRGVaUHBWeGw5YkRDeXlkVVRFUlpidW0zNncrU2N5VHhXZXFHTEtI?=
 =?utf-8?B?REllMUVWTWxwODhJZE1OaVJHTzJ0Uy94Ykx4RlA0aGV2bmxra0hmS1Z3OU5m?=
 =?utf-8?B?U2lIUDNlT1FGaDA5dHhhdVFkekFtVmdheU8rNi85SGZ2UlpPTzVwYmtncXVt?=
 =?utf-8?B?Rkgxa0VZK1VoUS9VbEUxOXk5ZWdJL2RXRTdWK1MvbDlYckU4YzZINUozTTFI?=
 =?utf-8?B?Rk1udGtrVTJtWVN0aytmeXQxTktxUkdrVDV5bnp5bDRhQmJVcHVNbkRSWCtV?=
 =?utf-8?B?bWkrTFZiT1dpWGNOZ2ZLRmZIenJGMFBjbnoyK1VPUzZ6NCs4SlBsSHE3WWtT?=
 =?utf-8?B?OU9Xakt0a2l4VHhqRXpBN3JKcElHU0VhMm8xRHprZldkYUM3ckRYSkRkdk53?=
 =?utf-8?B?aXFVQXZFWFBMbThQcXR6T1Q3VHNQTGFFV0JzVGpZbE5wZjFmL1hqSEJFbGtk?=
 =?utf-8?B?UDQ4RmtQSU81VVFpRXBYQVNwYUdmcVVMSEN6MG9KYXlJbXI2dTEvaEtVZWxI?=
 =?utf-8?B?T0JuKzQwMVkwbWo0VnRKQlN0SWhiZVRadm1taTU5bGQ4MzB3UE0zUHo5Z1dn?=
 =?utf-8?B?QlltRGlLTVM2dDFjVUozZDN3akNua3NsVXVoWkcrMGhrQmlPZXdFQVVZdmk0?=
 =?utf-8?B?bC9QRHM1TFA0bE05TjVRM3p0eU5IMFZSbHhPbTN3V0Q4L2lZa1lXNjdGNk5T?=
 =?utf-8?B?ZXRaS3NRNmllT3loWjdYSjBOeHFwaVZXWHl1K1ozM3ZOM01OM1NXRmZLc2VB?=
 =?utf-8?B?ZlBVU2crSUNXUm5USGRjejl0QXFYdzR6clBjMVlJZm1FbFYzOXBsSjhPaE5w?=
 =?utf-8?B?M2picDBqb2tRZ29TRDhwUm55Y0V4QTVIbDU5Lyt2aTJkTVNQTVZuNW9KcHhP?=
 =?utf-8?B?MWxxU2Z4QTJNTStUQ0V3TWlqczNDTFJ5bkpKcUg3ZE1RckhjaDcwUjNuZzBj?=
 =?utf-8?B?K21NUk9lVURRRm4zelYvR003VTJCQ0syMFF0TW1TcEIxV0xERTNHeFh1VjFT?=
 =?utf-8?B?Mk4wNUc5OVA5eTFEMnB1MWp1WXVMaHYrUStFaExrOEdTVzJHSXRhMG85cE5v?=
 =?utf-8?B?WkF4U0NlODRCZURmcTVZUnAyWkxIa3JMTWtmL2oxeWQrcTdLQm4razlucUVV?=
 =?utf-8?B?QlRKVlNqRjBJdE5nSW1Jc1pKYStYcjZvVm1zSElrS2xGZWxqZVBIWkF6cm1Z?=
 =?utf-8?B?bk8zeW9IUnJ2dTl3MHlUOUEyVm1BPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 140b8564-9e61-4fb3-97d7-08d9f5fa4d1d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:56:03.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jquDfQkNRKfozC04i4nxDrGlBa4Nl2LcPSu0xnw4EXMLD1MxOHeez5MN1tJZNvmMpB+LPa6dItfZpDCHYKMY3do0E2RAa6l22oloLEwuUd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=942 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220070
X-Proofpoint-GUID: va0Xwv75pGqO_2G4M9WumSR4fEgUR6QT
X-Proofpoint-ORIG-GUID: va0Xwv75pGqO_2G4M9WumSR4fEgUR6QT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 16:21, Jason Gunthorpe wrote:
> On Tue, Feb 15, 2022 at 04:00:35PM +0000, Joao Martins wrote:
>> On 2/14/22 14:06, Jason Gunthorpe wrote:
>>> On Mon, Feb 14, 2022 at 01:34:15PM +0000, Joao Martins wrote:
>>>
>>>> [*] apparently we need to write an invalid entry first, invalidate the {IO}TLB
>>>> and then write the new valid entry. Not sure I understood correctly that this
>>>> is the 'break-before-make' thingie.
>>>
>>> Doesn't that explode if the invalid entry is DMA'd to?
>>>
>> Yes, IIUC. Also, the manual has this note:
> 
> Heh, sounds like "this doesn't work" to me :)
> 
Yeah, but I remember reading in manual that HTTUD (what ARM calls it for dirty
tracking, albeit DBM is another term for the same thing) requires FEAT_BBM
which avoids us to play the above games. So, supposedly, we can "just"
use atomics with IOPTE changes and IOTLB flush. Not if we need the latter
flush before or after on smmuv3.

>>> Like I said, I'd prefer we not build more on the VFIO type 1 code
>>> until we have a conclusion for iommufd..
>>>
>>
>> I didn't quite understand what you mean by conclusion.
> 
> If people are dead-set against doing iommufd, then lets abandon the
> idea and go back to hacking up vfio.
>  
Heh, I was under the impression everybody was investing so much *because*
that direction was set onto iommufd direction.

>> If by conclusion you mean the whole thing to be merged, how can the work be
>> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
>> in terms of direction...
> 
> I think go ahead and build it on top of iommufd, start working out the
> API details, etc. I think once the direction is concluded the new APIs
> will go forward.
>
/me nods, will do. Looking at your repository it is looking good.

>>> While returning the dirty data looks straight forward, it is hard to
>>> see an obvious path to enabling and controlling the system iommu the
>>> way vfio is now.
>>
>> It seems strange to have a whole UAPI for userspace [*] meant to
>> return dirty data to userspace, when dirty right now means the whole
>> pinned page set and so copying the whole guest ... 
> 
> Yes, the whole thing is only partially implemented, and doesn't have
> any in-kernel user. It is another place holder for an implementation
> to come someday.
> 
Yeap, seems like.

>> Hence my thinking was that the patches /if small/ would let us see how dirty
>> tracking might work for iommu kAPI (and iommufd) too.
> 
> It could be tried, but I think if you go into there you will find it
> quickly turns quite complicated to address all the edge cases. Eg what
> do you do if you have a mdev present after you turn on system
> tracking? What if the mdev is using a PASID?
> What about hotplug of new
> VFIO devices?
> 
> Remember, dirty tracking for vfio is totally useless without also
> having vfio device migration. 

Oh yes -- I am definitely aware. IOMMU/Device Dirty tracking is useless
if we can't do the device part first. But if quiescing DMA and saving
state are two hard requirements that are mandatory for a live migrateable
VF, having dirty tracking in the devices I suspect might be more rare.
So perhaps people will look at IOMMUs as a commodity-workaround to avoid
a whole bunch of hardware logic for dirty tracking, even bearing what it
entails for DMA performance (hisilicon might be an example).

> Do you already have a migration capable
> device to use with this?
> 
Not yet, but soon I hope.

>> Would it be better to do more iterative steps (when possible) as opposed to
>> scratch and rebuild VFIO type1 IOMMU handling?
> 
> Possibly, but every thing that gets added has to be carried over to
> the new code too, and energy has to be expended trying to figure out
> how the half implemented stuff should work while finishing it.
> 
/me nods I understand

> At the very least we must decide what to do with device-provided dirty
> tracking before the VFIO type1 stuff can be altered to use the system
> IOMMU.
> 
I, too, have been wondering what that is going to look like -- and how do we
convey the setup of dirty tracking versus the steering of it.

> This is very much like the migration FSM, the only appeal is the
> existing qemu implementation of the protocol.

Yeah.
