Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA4455FA2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhKRPjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:39:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23004 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhKRPjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:39:11 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFDHx7019322;
        Thu, 18 Nov 2021 15:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NYngq7W4gYMj5IkR8pDqp8GRBff4Uqs6Nh7q+T4x0sI=;
 b=yuIoP3SP0lMO7t4RsXdKUM2eEhZJ597jh9E3BZVRD2ro2a/Nh8iSgbX4qSWmc1yg/qu0
 jR9h475NsO3pmxu5RvzLgMI2EL0WPIq9t2KpoQ95bxfK/t2rTjfNOdQD/+PTPlt5clyn
 LY/d7+2jiFvm5q676CPD5hzzHVfjZPjf8XEMTPKLyqXJ28oCI2JvDHoWaKZNWqVh0OvB
 T4Uo4AE2wDM39qmecIJ4xraT9LhfS92qC6IM9+jC/qrA3bMQdRO+2UYlwHSsPpCXcvl7
 IoCT4mY391trnqYc5NBr4ouWHBTvgm66d09p1pJzbUgmWgJdz0oGbKJTrwCQSyirpUGP HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2w8yqmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:36:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFYST3048927;
        Thu, 18 Nov 2021 15:35:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3ca2g0p6b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:35:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFihSam7kJR+dKXMDDhrJ0TrTPqZSUvIhCg4ooBmkMdicMin6+AF+UBCKnlor/qUulVs3FQSO3VOWM9OTa41LLrUhzU6+BvMbL7f9fkoMyC8sLkQQlTTod9wY22jGWsvJgGPGq9ylsveBV7x0Nu4zP6Lyl+vQ0YSqwtThHhE/Y7gSnjja3M5yIrwzdFOlhWEXXiBjuyDnwRTfiLwbmMk+mcIW4lA4ILJjzjKFsOmSzqEEDuggivWKspAu3P58vVnXJ/gYogcT5RG0W9PXbI2rRb5JMPwSens+Gtpc989dWCptVCGAgfdlBJIXGEZtHOSpuaX74kgpKRsNqAM1jrmUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYngq7W4gYMj5IkR8pDqp8GRBff4Uqs6Nh7q+T4x0sI=;
 b=ZfYXK27ki3jvLVXzY2YWgbuD/JYTEibwvN+E2pqUWZxAiJYJIF/KT+uAIGTtoC67lR4dAqg2eq0pOgBiXsH4NmQw8k4A7AvC3RAqexdwVRlXAl2EFPXR9TqChkRfC06OHuV8QvEX0aZR0d5dT4omvxr2gWVWEfk6y4LG2FBSel6DfTmOvioI6Q7AysO805IhTj5zDvhBLGwxj2KxipYI2JFkXiQ2o/1Ol1lKUSByKWTWbT55mShfYab5c4gPJEqBsLUUgblqlBJKEatTPGYgXeoPIqjkw1PLRn/BlMXFIGV9CznrrIJk5N819NrEDpN+2hhwT8bSSisFAE4K/9XMFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYngq7W4gYMj5IkR8pDqp8GRBff4Uqs6Nh7q+T4x0sI=;
 b=p1pSlBZqCmAGjAzTU4ph7wXp+X00ObjGo6BEirmzowMsUS+C0wgCFUeSBNgZLuNgn4EHepqzbUKWcPeXYxgtlEafLG1RKFRJq42LHOdaUGk19e2Td74sOo1DYxjzoTjs0ADONeBCI+ST+yudFGkbO94Po7EXnzeH9IGXZawBksk=
Received: from BLAPR10MB5138.namprd10.prod.outlook.com (2603:10b6:208:322::8)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 15:35:48 +0000
Received: from BLAPR10MB5138.namprd10.prod.outlook.com
 ([fe80::9418:7fcf:86ec:e0f4]) by BLAPR10MB5138.namprd10.prod.outlook.com
 ([fe80::9418:7fcf:86ec:e0f4%7]) with mapi id 15.20.4713.019; Thu, 18 Nov 2021
 15:35:48 +0000
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Hanna Reitz <hreitz@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: Re: [PATCH-for-6.2?] docs: Spell QEMU all caps
In-Reply-To: <20211118143401.4101497-1-philmd@redhat.com>
References: <20211118143401.4101497-1-philmd@redhat.com>
Date:   Thu, 18 Nov 2021 15:35:43 +0000
Message-ID: <m2lf1l8oj4.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DB6PR0301CA0097.eurprd03.prod.outlook.com
 (2603:10a6:6:30::44) To BLAPR10MB5138.namprd10.prod.outlook.com
 (2603:10b6:208:322::8)
MIME-Version: 1.0
Received: from oracle.com (46.7.162.180) by DB6PR0301CA0097.eurprd03.prod.outlook.com (2603:10a6:6:30::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 15:35:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1990e7eb-d574-48a4-a4e0-08d9aaa9182d
X-MS-TrafficTypeDiagnostic: BLAPR10MB4963:
X-Microsoft-Antispam-PRVS: <BLAPR10MB4963D465A2218EFDF7610E15F49B9@BLAPR10MB4963.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: urYXMg6f3Lz2Fkvf8b2ln36XuNPy0gGX9kRqBgPW6NKCTy6fiNox2VVLxsBBXfIC53ewDX/JhDJ78blXHF2X9ova8XTWDvzRV+CgOiM9QDKJ5w/noik5G9iVlHKe1GQX+nGFOt37qAjfN8D3aGDVoB6n7+FPS6Vyipayp2k3PS3KU4fh0ydkVZRcXXq0KUyZBfLpVIGozj8jWRwjjJIhfvZu4qtEEuF5PnBk4FPA4GD79k7QCGFppHUEa78/LYBtA5LdyPxwDCD/YsJrLrpmaDYvU1tmJqPirgAOTxVWj8rsIKgiEk782niM3zVtaMy84ABtGXgwI6tcKTvVKChT3sTXhmuhsIFczpPaZSyn9q/8h7ePUhpOAq25lWIpjBolm9ByfbnkgeEPR0q7rFB5qKelEzvUTGmIpfzXKUOodcc2Atsbu/p1AggFQ624ftrFXW4Oqp2VlZ0RPRs+kZTeyt8L0mcmHVAY/VAsY3wjIvwkm9c2D7N5kO1pZiRIqn1/htKEbFiRrVWjcn76ogYr7MI+ccEe+dhx/1UjM2BJnsl1CBv9al7mPOR270tUSudJpi0cp+rMJAMxRClgj+zTpVk5cnoMLwNJ3pSkfsXtZI2AMTaLxZGTwkwxuTQ+fzGWWX6K6gaHNGdpExkYf5JLJpy6DZ07OCfSN1NnQz5EoKjE1MwLpNkjuOBHuQ6WtqqJSGdv3yHKHuI4WsStQrdG37/F3knzvacZ3rddOqjSp/Mp2VkoYMXaQa1FgMEnGUVoryl+WdVtor0UG0YDR7JsVWPekrZf7Dn+XgKYKfZ2An8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5138.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(8886007)(52116002)(54906003)(4326008)(55016002)(2616005)(956004)(8936002)(6666004)(66476007)(7696005)(966005)(66556008)(66946007)(7416002)(44832011)(36756003)(38350700002)(8676002)(5660300002)(186003)(30864003)(508600001)(83380400001)(4001150100001)(316002)(2906002)(26005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGtYU1d2SFB4cGxPZ0dCbTU4QThiY29uc2Nub2hjbUtYSE45NUpBNWJHQ3lO?=
 =?utf-8?B?TVNQUm8rcFBNK0pjbndVZXVEeVZKSktJdE5NM3A1eUNRTmpxTTJwYmtTaXQ5?=
 =?utf-8?B?K0xJWjB4Vm5GUW5ySVkvN2lCZ3N2RWhicFBoUGh4Z21vZXV4YStRVE1lM0Yw?=
 =?utf-8?B?SS9ncUkwWDBkemRhSG0wNjNvc0syR1ZIQktyRFlaWnp5c294UmdlVk5YUHNZ?=
 =?utf-8?B?U0U5ZzFaN3h3Qnd3WC9Od0w3SHpkZXZNSmxHRVVNamlWeVlkVzltTm9mWXNj?=
 =?utf-8?B?RWhKck96WUQ2eXRYcS9WUUNDN2g1d0JmUWlabmdPaEpVanhTUDdzdDZGRThZ?=
 =?utf-8?B?SjNBUitFcXp6UjNGbnNBbTNVSmNiTXlOc2dza0lDZk42Z1BmTHpCOGViYW42?=
 =?utf-8?B?aUtkZ2lFMGNPa3JTd2pCVjFwTUpvV1VPM1pTYkZOTHRsdVErWDFOUW9MbFJj?=
 =?utf-8?B?WllRQTZ4SFNzN3UvYzFocm4zNHQ2MG1mZThxcmsweEZwK3gyRmcyRlZndWlH?=
 =?utf-8?B?OE5qZHh3aUpnaEtzcVd0U3dyUmtsZjFteGRxTGZzTTVhcTJqMVVkaHNaMC9i?=
 =?utf-8?B?cFlnR0dVUXgwY2k1VHNvcmw2eGNMeFEyekcwWjBNaCtkNW41K1lvT1pZMWpj?=
 =?utf-8?B?eTlMSFdVaTB3VHVZWDEwcjhQL1ZYSFVVOWNib2liSTFUNXpRUUI4WXBGUEts?=
 =?utf-8?B?SHd3MVNDaFdmRTV3bVFmYTY3RE4xcHhjOXJ5TThiVlBJaUt5T2dTa3JOMCtS?=
 =?utf-8?B?anFvS2ZyYm9Tb3VZeTBYbkVydlV5QlJ2VFRxbENodk96WGg0K2NQMHBtOWRK?=
 =?utf-8?B?ZXcycVFBU3o4NkxraG5zWDFSTHVzdXMrcUpIOE5lSkp2dEl1YVc3ZzZPN1V0?=
 =?utf-8?B?YmM1OTZza1BOVnQzWEdqRGljTEpJZHBnNWo3N21HZzlFM0gyNnhKRWNFd1RH?=
 =?utf-8?B?UU1JUXhGbUxnZUNSQ3JqVHdxelp2VWJqV0NVMjdoRVZ3Umx1TGpJamYyMGpM?=
 =?utf-8?B?ckEvSmhnYmZodHJIRUczYVBiZ1NzclBqMGFaMmxCZW9oTlhWRVJLU2JGMkhS?=
 =?utf-8?B?TUhOdHI5OWhIcHpPTW9VTjRBYWlPUC9oaDJEYjZ1MFY3M2M4dDdpWWFON0lx?=
 =?utf-8?B?REZMSkdWRzFIQXh5R3FiNExHRkFGRjdXdW1wMThValBWRjMwazViL3BTbEtT?=
 =?utf-8?B?Ym1JOXRjTW9pS3JzZjNJWS9YY2lLL3c1ZHVtanJhZllmT2tFUDdJZlo1WEdp?=
 =?utf-8?B?Ti80ZFd2ZUs1YlRQY0puS1pqRE5wWkxVazhkcEo4YVk2ay80cGQ2K1EycGxL?=
 =?utf-8?B?clgzamdEeXkwdWMyZ2tnVEtMY3EyYVJVb0FWTnZqRkw1WHdyN1VMcEVRWk9O?=
 =?utf-8?B?QWN5TncrTGVFRlJ4TkExQVh3NWl6cmZSZEczbXZVbmRSZ2FRQTBIbWRkdkdr?=
 =?utf-8?B?L0Q3NXFFcG4vcFFxRFBLaW50MWxUdkI1Mkh3YWs1N0FDQUFIM3ROaVo1ajJ3?=
 =?utf-8?B?ZkNpM05DVU1icjJFRmZGWUJ5RTR0VXVaM2ZUY2RrSTVDcXQxVThPN1VMd0Ra?=
 =?utf-8?B?eERJZEc3YzlmVHZwSVQ0ZDNrQWpTUEZrd0RSNEhyRE9OWWpkYndVQk9GbkZr?=
 =?utf-8?B?ODVoWUk1RFNRQ1p3cXNKOVhmUFJHZnA2T3pWSld2MXh6blp2UUlteGljL2tU?=
 =?utf-8?B?ZTh2bGFIWkl6MXcwbWRmbWRzOC83L25GbUdpM1FmSm1OYnNXb0JvUXVFQkpn?=
 =?utf-8?B?SXo1UXpQTTEzc094UmtLQ0JrQXBKTHZ3Rno0OGpyK0h4dmxiTmNMcmNHNkFK?=
 =?utf-8?B?YklqdVZQcTJpMExCamtqYmYybUNyYUpNc1p3bnRrWm1YYTVmVHNZbysxRG5j?=
 =?utf-8?B?OUQxNy9mdlhXMUNRTm1FSlBjWUlhaUhIdEpUR2dSUUFpSFNBa1JrTENBMXND?=
 =?utf-8?B?UHhEOVl2ZURQN2xNTVF6S2J4OXBFTEpBSGlHc0NCbnJocGxwZUdGRGpBK1ly?=
 =?utf-8?B?clNKNDhTSlBDSmo0aFpCMU9wQmtVNmJqTnorWjVYdmVFeXFWSkZBd3BBT21n?=
 =?utf-8?B?WHM4UUQxbmxtbkhaTkdKc3NBME1KTWVxbFZWWTJoekozT2dZT0ZxUTZtVWVG?=
 =?utf-8?B?MkNDL2NZSnlFNGJuUlk5dnRIZXBnSUV2dXMyZ285YllUTU1ZL2ozcW9BZzdr?=
 =?utf-8?Q?scB8ZUEXbPKQw0dtyhz1A98=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1990e7eb-d574-48a4-a4e0-08d9aaa9182d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5138.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 15:35:48.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1BwUVYliLeNHUqKe8Hr07Cr/rskKxPjyW2TAOdNTZ9/Wg1UkoyiAsY8mRZFKE794FweBOPIIod/eaf0M0MLdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180086
X-Proofpoint-GUID: TkL6R2mODkrkMj1PKNSlOLNjXqeuW3s7
X-Proofpoint-ORIG-GUID: TkL6R2mODkrkMj1PKNSlOLNjXqeuW3s7
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-11-18 at 15:34:01 +01, Philippe Mathieu-Daud=C3=A9 wrote:
> Replace Qemu -> QEMU.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  docs/devel/modules.rst                |  2 +-
>  docs/devel/multi-thread-tcg.rst       |  2 +-
>  docs/devel/style.rst                  |  2 +-
>  docs/devel/ui.rst                     |  4 ++--
>  docs/interop/nbd.txt                  |  6 +++---
>  docs/interop/qcow2.txt                |  8 ++++----
>  docs/multiseat.txt                    |  2 +-
>  docs/system/device-url-syntax.rst.inc |  2 +-
>  docs/system/i386/sgx.rst              | 26 +++++++++++++-------------
>  docs/u2f.txt                          |  2 +-
>  10 files changed, 28 insertions(+), 28 deletions(-)
>
> diff --git a/docs/devel/modules.rst b/docs/devel/modules.rst
> index 066f347b89b..8e999c4fa48 100644
> --- a/docs/devel/modules.rst
> +++ b/docs/devel/modules.rst
> @@ -1,5 +1,5 @@
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -Qemu modules
> +QEMU modules
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  .. kernel-doc:: include/qemu/module.h
> diff --git a/docs/devel/multi-thread-tcg.rst b/docs/devel/multi-thread-tc=
g.rst
> index 5b446ee08b6..c9541a7b20a 100644
> --- a/docs/devel/multi-thread-tcg.rst
> +++ b/docs/devel/multi-thread-tcg.rst
> @@ -228,7 +228,7 @@ Emulated hardware state
> =20
>  Currently thanks to KVM work any access to IO memory is automatically
>  protected by the global iothread mutex, also known as the BQL (Big
> -Qemu Lock). Any IO region that doesn't use global mutex is expected to
> +QEMU Lock). Any IO region that doesn't use global mutex is expected to
>  do its own locking.
> =20
>  However IO memory isn't the only way emulated hardware state can be
> diff --git a/docs/devel/style.rst b/docs/devel/style.rst
> index 260e3263fa0..e00af62e763 100644
> --- a/docs/devel/style.rst
> +++ b/docs/devel/style.rst
> @@ -686,7 +686,7 @@ Rationale: hex numbers are hard to read in logs when =
there is no 0x prefix,
>  especially when (occasionally) the representation doesn't contain any le=
tters
>  and especially in one line with other decimal numbers. Number groups are=
 allowed
>  to not use '0x' because for some things notations like %x.%x.%x are used=
 not
> -only in Qemu. Also dumping raw data bytes with '0x' is less readable.
> +only in QEMU. Also dumping raw data bytes with '0x' is less readable.
> =20
>  '#' printf flag
>  ---------------
> diff --git a/docs/devel/ui.rst b/docs/devel/ui.rst
> index 06c7d622ce7..17fb667dec4 100644
> --- a/docs/devel/ui.rst
> +++ b/docs/devel/ui.rst
> @@ -1,8 +1,8 @@
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -Qemu UI subsystem
> +QEMU UI subsystem
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -Qemu Clipboard
> +QEMU Clipboard
>  --------------
> =20
>  .. kernel-doc:: include/ui/clipboard.h
> diff --git a/docs/interop/nbd.txt b/docs/interop/nbd.txt
> index 10ce098a29b..bdb0f2a41ac 100644
> --- a/docs/interop/nbd.txt
> +++ b/docs/interop/nbd.txt
> @@ -1,4 +1,4 @@
> -Qemu supports the NBD protocol, and has an internal NBD client (see
> +QEMU supports the NBD protocol, and has an internal NBD client (see
>  block/nbd.c), an internal NBD server (see blockdev-nbd.c), and an
>  external NBD server tool (see qemu-nbd.c). The common code is placed
>  in nbd/*.
> @@ -7,11 +7,11 @@ The NBD protocol is specified here:
>  https://github.com/NetworkBlockDevice/nbd/blob/master/doc/proto.md
> =20
>  The following paragraphs describe some specific properties of NBD
> -protocol realization in Qemu.
> +protocol realization in QEMU.
> =20
>  =3D Metadata namespaces =3D
> =20
> -Qemu supports the "base:allocation" metadata context as defined in the
> +QEMU supports the "base:allocation" metadata context as defined in the
>  NBD protocol specification, and also defines an additional metadata
>  namespace "qemu".
> =20
> diff --git a/docs/interop/qcow2.txt b/docs/interop/qcow2.txt
> index 0463f761efb..f7dc304ff69 100644
> --- a/docs/interop/qcow2.txt
> +++ b/docs/interop/qcow2.txt
> @@ -313,7 +313,7 @@ The fields of the bitmaps extension are:
>                     The number of bitmaps contained in the image. Must be
>                     greater than or equal to 1.
> =20
> -                   Note: Qemu currently only supports up to 65535 bitmap=
s per
> +                   Note: QEMU currently only supports up to 65535 bitmap=
s per
>                     image.
> =20
>            4 -  7:  Reserved, must be zero.
> @@ -775,7 +775,7 @@ Structure of a bitmap directory entry:
>                        2: extra_data_compatible
>                           This flags is meaningful when the extra data is
>                           unknown to the software (currently any extra da=
ta is
> -                         unknown to Qemu).
> +                         unknown to QEMU).
>                           If it is set, the bitmap may be used as expecte=
d, extra
>                           data must be left as is.
>                           If it is not set, the bitmap must not be used, =
but
> @@ -793,7 +793,7 @@ Structure of a bitmap directory entry:
>               17:    granularity_bits
>                      Granularity bits. Valid values: 0 - 63.
> =20
> -                    Note: Qemu currently supports only values 9 - 31.
> +                    Note: QEMU currently supports only values 9 - 31.
> =20
>                      Granularity is calculated as
>                          granularity =3D 1 << granularity_bits
> @@ -804,7 +804,7 @@ Structure of a bitmap directory entry:
>          18 - 19:    name_size
>                      Size of the bitmap name. Must be non-zero.
> =20
> -                    Note: Qemu currently doesn't support values greater =
than
> +                    Note: QEMU currently doesn't support values greater =
than
>                      1023.
> =20
>          20 - 23:    extra_data_size
> diff --git a/docs/multiseat.txt b/docs/multiseat.txt
> index 11850c96ff8..2b297e979d6 100644
> --- a/docs/multiseat.txt
> +++ b/docs/multiseat.txt
> @@ -123,7 +123,7 @@ Background info is here:
>  guest side with pci-bridge-seat
>  -------------------------------
> =20
> -Qemu version 2.4 and newer has a new pci-bridge-seat device which
> +QEMU version 2.4 and newer has a new pci-bridge-seat device which
>  can be used instead of pci-bridge.  Just swap the device name in the
>  qemu command line above.  The only difference between the two devices
>  is the pci id.  We can match the pci id instead of the device path
> diff --git a/docs/system/device-url-syntax.rst.inc b/docs/system/device-u=
rl-syntax.rst.inc
> index d15a0215087..7dbc525fa80 100644
> --- a/docs/system/device-url-syntax.rst.inc
> +++ b/docs/system/device-url-syntax.rst.inc
> @@ -15,7 +15,7 @@ These are specified using a special URL syntax.
>     'iqn.2008-11.org.linux-kvm[:<name>]' but this can also be set from
>     the command line or a configuration file.
> =20
> -   Since version Qemu 2.4 it is possible to specify a iSCSI request
> +   Since version QEMU 2.4 it is possible to specify a iSCSI request
>     timeout to detect stalled requests and force a reestablishment of the
>     session. The timeout is specified in seconds. The default is 0 which
>     means no timeout. Libiscsi 1.15.0 or greater is required for this
> diff --git a/docs/system/i386/sgx.rst b/docs/system/i386/sgx.rst
> index 9aa161af1a1..f8fade5ac2d 100644
> --- a/docs/system/i386/sgx.rst
> +++ b/docs/system/i386/sgx.rst
> @@ -20,13 +20,13 @@ report the same CPUID info to guest as on host for mo=
st of SGX CPUID. With
>  reporting the same CPUID guest is able to use full capacity of SGX, and =
KVM
>  doesn't need to emulate those info.
> =20
> -The guest's EPC base and size are determined by Qemu, and KVM needs Qemu=
 to
> +The guest's EPC base and size are determined by QEMU, and KVM needs QEMU=
 to
>  notify such info to it before it can initialize SGX for guest.
> =20
>  Virtual EPC
>  ~~~~~~~~~~~
> =20
> -By default, Qemu does not assign EPC to a VM, i.e. fully enabling SGX in=
 a VM
> +By default, QEMU does not assign EPC to a VM, i.e. fully enabling SGX in=
 a VM
>  requires explicit allocation of EPC to the VM. Similar to other speciali=
zed
>  memory types, e.g. hugetlbfs, EPC is exposed as a memory backend.
> =20
> @@ -35,12 +35,12 @@ prior to realizing the vCPUs themselves, which occurs=
 long before generic
>  devices are parsed and realized.  This limitation means that EPC does no=
t
>  require -maxmem as EPC is not treated as {cold,hot}plugged memory.
> =20
> -Qemu does not artificially restrict the number of EPC sections exposed t=
o a
> -guest, e.g. Qemu will happily allow you to create 64 1M EPC sections. Be=
 aware
> +QEMU does not artificially restrict the number of EPC sections exposed t=
o a
> +guest, e.g. QEMU will happily allow you to create 64 1M EPC sections. Be=
 aware
>  that some kernels may not recognize all EPC sections, e.g. the Linux SGX=
 driver
>  is hardwired to support only 8 EPC sections.
> =20
> -The following Qemu snippet creates two EPC sections, with 64M pre-alloca=
ted
> +The following QEMU snippet creates two EPC sections, with 64M pre-alloca=
ted
>  to the VM and an additional 28M mapped but not allocated::
> =20
>   -object memory-backend-epc,id=3Dmem1,size=3D64M,prealloc=3Don \
> @@ -54,7 +54,7 @@ to physical EPC. Because physical EPC is protected via =
range registers,
>  the size of the physical EPC must be a power of two (though software see=
s
>  a subset of the full EPC, e.g. 92M or 128M) and the EPC must be naturall=
y
>  aligned.  KVM SGX's virtual EPC is purely a software construct and only
> -requires the size and location to be page aligned. Qemu enforces the EPC
> +requires the size and location to be page aligned. QEMU enforces the EPC
>  size is a multiple of 4k and will ensure the base of the EPC is 4k align=
ed.
>  To simplify the implementation, EPC is always located above 4g in the gu=
est
>  physical address space.
> @@ -62,7 +62,7 @@ physical address space.
>  Migration
>  ~~~~~~~~~
> =20
> -Qemu/KVM doesn't prevent live migrating SGX VMs, although from hardware'=
s
> +QEMU/KVM doesn't prevent live migrating SGX VMs, although from hardware'=
s
>  perspective, SGX doesn't support live migration, since both EPC and the =
SGX
>  key hierarchy are bound to the physical platform. However live migration
>  can be supported in the sense if guest software stack can support recrea=
ting
> @@ -76,7 +76,7 @@ CPUID
>  ~~~~~
> =20
>  Due to its myriad dependencies, SGX is currently not listed as supported
> -in any of Qemu's built-in CPU configuration. To expose SGX (and SGX Laun=
ch
> +in any of QEMU's built-in CPU configuration. To expose SGX (and SGX Laun=
ch
>  Control) to a guest, you must either use ``-cpu host`` to pass-through t=
he
>  host CPU model, or explicitly enable SGX when using a built-in CPU model=
,
>  e.g. via ``-cpu <model>,+sgx`` or ``-cpu <model>,+sgx,+sgxlc``.
> @@ -101,7 +101,7 @@ controlled via -cpu are prefixed with "sgx", e.g.::
>    sgx2
>    sgxlc
> =20
> -The following Qemu snippet passes through the host CPU but restricts acc=
ess to
> +The following QEMU snippet passes through the host CPU but restricts acc=
ess to
>  the provision and EINIT token keys::
> =20
>   -cpu host,-sgx-provisionkey,-sgx-tokenkey
> @@ -112,11 +112,11 @@ in hardware cannot be forced on via '-cpu'.
>  Virtualize SGX Launch Control
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> =20
> -Qemu SGX support for Launch Control (LC) is passive, in the sense that i=
t
> -does not actively change the LC configuration.  Qemu SGX provides the us=
er
> +QEMU SGX support for Launch Control (LC) is passive, in the sense that i=
t
> +does not actively change the LC configuration.  QEMU SGX provides the us=
er
>  the ability to set/clear the CPUID flag (and by extension the associated
>  IA32_FEATURE_CONTROL MSR bit in fw_cfg) and saves/restores the LE Hash M=
SRs
> -when getting/putting guest state, but Qemu does not add new controls to
> +when getting/putting guest state, but QEMU does not add new controls to
>  directly modify the LC configuration.  Similar to hardware behavior, loc=
king
>  the LC configuration to a non-Intel value is left to guest firmware.  Un=
like
>  host bios setting for SGX launch control(LC), there is no special bios s=
etting
> @@ -126,7 +126,7 @@ creating VM with SGX.
>  Feature Control
>  ~~~~~~~~~~~~~~~
> =20
> -Qemu SGX updates the ``etc/msr_feature_control`` fw_cfg entry to set the=
 SGX
> +QEMU SGX updates the ``etc/msr_feature_control`` fw_cfg entry to set the=
 SGX
>  (bit 18) and SGX LC (bit 17) flags based on their respective CPUID suppo=
rt,
>  i.e. existing guest firmware will automatically set SGX and SGX LC accor=
dingly,
>  assuming said firmware supports fw_cfg.msr_feature_control.
> diff --git a/docs/u2f.txt b/docs/u2f.txt
> index 8f44994818a..7f5813a0b72 100644
> --- a/docs/u2f.txt
> +++ b/docs/u2f.txt
> @@ -21,7 +21,7 @@ The second factor is materialized by a device implement=
ing the U2F
>  protocol. In case of a USB U2F security key, it is a USB HID device
>  that implements the U2F protocol.
> =20
> -In Qemu, the USB U2F key device offers a dedicated support of U2F, allow=
ing
> +In QEMU, the USB U2F key device offers a dedicated support of U2F, allow=
ing
>  guest USB FIDO/U2F security keys operating in two possible modes:
>  pass-through and emulated.
> =20
> --=20
> 2.31.1
