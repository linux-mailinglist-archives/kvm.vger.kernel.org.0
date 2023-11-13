Return-Path: <kvm+bounces-1614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1E57EA2AB
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 19:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C18A1C2098C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 18:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1233C22F08;
	Mon, 13 Nov 2023 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSznAggZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uvqcGLcv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D39C22EFA
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 18:17:29 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72BBD75
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 10:17:27 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADHifjx019480;
	Mon, 13 Nov 2023 18:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=TkQ9WG5YLLJPdhw7FLB9259sdO3Z7Cd1Lw58iVkyvwg=;
 b=kSznAggZr+hLXFQJxOmFlWEta62Pnq6gY+/vYbSD8ntC8ZkfzqTZ1Xq/jLr2dxHXoJkQ
 dSb7CQ1wKjJbOAfvyuN5fr7ASXZq1gzqWVjxN4v2U6fSsh/8Dki6tQHwwC6p+EFM4riU
 acHxtdxrC4yuTzzHeHrKszUhhUbbFiTAYHvIe/cU5ZX2YwTnbJ+alQr4FCajIu6rI9q4
 hPoEOWaBV1t0XQA57c1eYPTHWyMOBs7OihpPbz0dvwRRSpaQo+UGbJRRwsD8U8CuIeON
 1hzCGQcIRwM9pVnh9mbT7gbgzdhKg9CuzowEb5xB3hi7udJFYyfBWtP61ocV19EOW6Oz PQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2bedj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Nov 2023 18:16:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADHoDsT022790;
	Mon, 13 Nov 2023 18:16:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpx1pr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Nov 2023 18:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lo7DXUiYEXglxoLOc+69XxDKtzZMhPwAbsRWwN9uANopQtrmBi1EXyazjiW69J7DXh6mhf0rJ2OVsjC3RGzqWQaL+20urtOMQD19VCkc9SxxO2oSgRTzlMz1ARQ3t2U6hu1lDnWm6f7/yMKFmzGtG30G7KKrlv+db4Yh/Pj3Po6Nlb4GNgDH1ywe0gCbRzktUNoZ/EVPeGa2tU4AP3CJySp+guxTI36pizqOuXDFLPPUw3+HjkqWPBLLFhptFC3DXheceiWOvs8f++KaAnSwJs50TzIQ2gkpmDQsHCDoew1XNJ/r0ytQQwF6IN92unL6vy7/EHnYgBzZtMmCzumuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkQ9WG5YLLJPdhw7FLB9259sdO3Z7Cd1Lw58iVkyvwg=;
 b=YN9WIxm2eZd3ugTsR4VAVqSo81bTBiRz+9WQKdEKRg9bKtxKdkhRvM6DX35MuvBcmxj8lpdK7LIIgM9iTVW+k90L24mnFz6YW3r+FQtfXnrNylabpQWNIeuSqPW5ql8d12BG75rwOns9LcSNMmiMdM4XN4f8kWdF92gjvQIX/Q+c800Myh40zHK/gh962Wt/sc2w64kScXcPYOZrOKBJ4IP3ZZGQxocKYYN5HAXYR90tQtXPT5u+YuheHCpNOzbcGLXQ0ZzR7g/fO/HVRGHt7OMzAdHqi//mRkcFzjBzJVOcKIHDPFem8Txt/hf9CU9g7fFuAKYO3foHbFo7vYmq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkQ9WG5YLLJPdhw7FLB9259sdO3Z7Cd1Lw58iVkyvwg=;
 b=uvqcGLcvlBacFXfQkHne6TxtXFFzx2EP1QSS0wNiVyuhLYiYV62vmrqkVUq2s25X+aXv5gNBJXpQLNNTPcRUs3X5y4XCFrfHnKyJHkRjAU201xXNPOzUVijb/lMfgMlKk7n6UK9ZlJIuSMDJ+zInqzy8Cty3JXpG4uhsGA/T3eU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MW4PR10MB6656.namprd10.prod.outlook.com (2603:10b6:303:227::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.28; Mon, 13 Nov
 2023 18:16:02 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 18:16:02 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com
Subject: [PATCH v3 1/1] target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
Date: Mon, 13 Nov 2023 10:07:01 -0800
Message-Id: <20231113180701.209534-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|MW4PR10MB6656:EE_
X-MS-Office365-Filtering-Correlation-Id: 294cecbe-542b-450d-8d33-08dbe4749805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0WvpefL4jUFCzZsi0Raq5N0Yp/H9I896bf/l6zFLNvy7NZpiGpOoVRrwFoiiNuSndcgyGmhULUgg/LUBXgueeucg545rjQPR80XU7BRoMUSwD30pQWv3sQ9cxcF+vKcwSjlqmSKaQSLgyfxF5asRJRb0IA29uk2hCGQr7THw3X3De+ONe5SLdijNSYsMt8YlUGOpqj+0M+XoQMBwEyKL2dMb919BR8bqPEY6XUYsLOCnXbP7/SvZVxF0cvdxfywuXFm2qp2bMPJXZwxVRNKv23Iu/x7sYBpk52+Q/9V89UngRTXOt3xLVOtkVElaTO3f22MWnVBVKnWZT1BYdt8hh9WZWfNtWFJPk0+h/jqfF4YBHkddHLV0zrdASHKdGoWuumHMD5owsoOThuxPBAVqR8y9TXbFothR5HPojgSfcqKU4obkTw28KR2nkphc+GiKNwiHdPfiEc9mG2JquKR3t5JWeUyi8AhAy6Qzer6KRcgZeBAt0zvj7gYhhAXFu8eaZc84LB7759fX0qdcL3c/784KYcJTWTPnMDdpsJhGDKI6/ycKqL+IzaU7z1YcGP/4ouNVRc5bZz/WIyY6ybQTWw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(39860400002)(366004)(396003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(26005)(6506007)(2616005)(6512007)(83380400001)(44832011)(5660300002)(8676002)(8936002)(41300700001)(4326008)(7416002)(2906002)(6486002)(966005)(478600001)(66556008)(66946007)(66476007)(316002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?aA9ZplFtDe3f7QGNinnOUz6/1qhN4W00+JzQtEKN75vqSmfc28W5e1j3joxa?=
 =?us-ascii?Q?r8mhR3DOSiJvBFCtFgKSVj/2jI69OLOe5aGZA/e7ugPf5pvbgWY8pdMUpTPu?=
 =?us-ascii?Q?VGI9wTncB94c7aXUOxed95E3ruQyTawIdLOMm+fdGe4m5HQTxDXERXfFfnsM?=
 =?us-ascii?Q?ERxUVFwixPMKG8EOr3rVUQN05GlC2EAxWBXGIPNhQAhk8QZ8W0NlbbA9Zad4?=
 =?us-ascii?Q?0q2+CEYUM4gY6wBPz+Zu0aPF3vdKKn7NOOW8gql43WEsrckAoAKRFrRBqbl+?=
 =?us-ascii?Q?ePRupucx2o+ElH66rddQsEu3n/f85kjbFYQxbRcuTDbXJSoLBI43mq9Uufz+?=
 =?us-ascii?Q?q0M2V/dUPFMKWlko2a8UT2Ligv58KDYsUlREpFEY/vxgdvGFDS9dXrESKcLI?=
 =?us-ascii?Q?MwrnSJZNRW1BCxkdsZ25n2NHrh+V/iwutF9r/NwwQrp9s8xs8wV54udVtCun?=
 =?us-ascii?Q?aEwvrSVOrAGEnBlrPNV7BaNg4cTD75fNyxBCwp7N2vwx13bCpg6LD0p5xl+9?=
 =?us-ascii?Q?lrN45WSBaErz/VOUTiwLhc3At+0XNZNpnwIh5nCmscDlEKJxvdrSiE1Cw9KP?=
 =?us-ascii?Q?jOFQSJ1rynDDRD81fKibN3baVtVYUcdPcx5mgwtIeRt98hXz5Ro5Eb/x4qSb?=
 =?us-ascii?Q?ke23nFGOkw5ORBlm68UG/gHq3j01hN8g0YlTKd1TBKOp0MuHgr4RpQNvZzx4?=
 =?us-ascii?Q?rvFTwA4Vxt+mYJaO3EKfHu/B1KQyEYhROHvWzEx33bRygQWkkMyHT3xNo7BP?=
 =?us-ascii?Q?XaIm3iOVnQzDR/QDPr31u4yOjb1pRQdqRBFT1FODshCqzBxJmPD/W2sFSLEn?=
 =?us-ascii?Q?Yztsl21BUHQwpJCzWHCkKZi6gvHokuuNFZWPOPcmK0t6XSPBCC+70NKjKom9?=
 =?us-ascii?Q?AmS80/a/ZjZxMAMLEqg0j1mI4w4lKnAv7SeyhjWwRMILlPsAcyfx9lc3xmhy?=
 =?us-ascii?Q?ZOOaB+X5fQg9TEUSHNcDhG3udUDQenWuW3TVuJm/VxvJUyHmJpAv0gc/jdF2?=
 =?us-ascii?Q?EgUOpugGs3xrhpcs2dtWpUJxByyr5ZozGw8DeNivreFwXJvbuflNH3JRiGos?=
 =?us-ascii?Q?GNYB3Z1TfTlJKCUt8idBVMEJaEIIkFAbOt2i4/J1EuUA87z/d84LzWuX3G0y?=
 =?us-ascii?Q?7X1YUyFj1sJ1BA0NiYfoHsroYrXkMbYAZv+Sb7u1y5WqVc0rFHj4UFmJpKCt?=
 =?us-ascii?Q?lryuGyzLesJMXgmqUGnlVp5aOonkLYfoCVdQ8dDsOkusPgr05hWAE56TvTQK?=
 =?us-ascii?Q?bXavr0FJsXp9V9aMuZZiKlTGYh7/QbRhOblAEEDk8ZZIgq9sRpCu54DYb+ui?=
 =?us-ascii?Q?v0YM+dkmPvMjhE8isTk32Ye/vTwp2JvR16c5RyRSModu4iKczk6GmlidufP+?=
 =?us-ascii?Q?xI5ilHVLSvrCZ929rAjLQ6J0frg2L6kR01x6qDY+Wr9uZhTIq1qiD0WqezvC?=
 =?us-ascii?Q?3WUvkUOo6g+VjXyosED6xo837vPYh21ukLfJXF3xGTl6LU2bhF33vVyUEMJJ?=
 =?us-ascii?Q?7APo3PO2cxCu2ASy/G0WjIc09sFHiyWLsDf3Hj29JkDpb1cgmz51Dcvm6cfN?=
 =?us-ascii?Q?Xe0QurvLySspRPKdyDrgezhf15Si0IXqduWoH4v+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?M3BNUCnsYBGUKpKZAg2Z5A3gb/27zwjryM7mDYc/BvfkscU04Tm/M/D3UcpV?=
 =?us-ascii?Q?XvLNjyLE1b1G+jA9Do7nH7b9K3qNJHLM8/AE6ipi7extIFJPiojrPoH+cOAX?=
 =?us-ascii?Q?b+ndh+plEb2gONiZj0Xwq0iR9neK9sBGJsDxV1wCXo8g9hLoySJSfUkbBPzn?=
 =?us-ascii?Q?sEl87GRlMne0GiOQJYLXfIst/yJxz+3muKD5A912lemBxZXOkKgkgPt2OBCi?=
 =?us-ascii?Q?9csOrNGURfw1NaeKhri0bPsUwl43X5gDUO+E3BanpyTpjouSbGDEQtBpcUCO?=
 =?us-ascii?Q?+6+78IBUh94t9ELVhP1Tr6HT2JFIVcv/XsNq9g1tIUj1W6uSZysp0ui0g2qG?=
 =?us-ascii?Q?5bAmmdFKlwQg50NLN6G3Dg1vQwLBRB18JRXT0b3f+uNJuQffVitEZRzDNFw1?=
 =?us-ascii?Q?m/UJOwJnfGtNv+y5svwE9mVXX1k63of1ed0EqIo1H7zDLsuVWYX+Kd+wy+uI?=
 =?us-ascii?Q?bhkJ6jRjZcCiiqcrQziSLoG3rKdHIA3KfxkQ1FW5zREKGztJsvzXjs/6SfC9?=
 =?us-ascii?Q?0xMmNcLB/pEZMvumYcmcKl7aOU+iCH816MPkspiSvqfyjkkZLR5umXaNyBPl?=
 =?us-ascii?Q?S6lVvj4R4CwwVBzJjUddatRq6ekWoKtFsggx/1APbZOiNXMEsxBPVYuXmk7C?=
 =?us-ascii?Q?ucIpVhRzoTPq+yIA8cJPIgEVoR7pY/XldtyAEfeILlBmrKgIapQs9olNzJeh?=
 =?us-ascii?Q?8/PMqbUpDGaS6iJu4TvWP40fXMQBbJMhoP/TBnxPJqEr/oHa5ORKYYewCipL?=
 =?us-ascii?Q?eIshETNhV+4d7FisI2nFEm173gokbSRd3AJwaX7/NhXSfCoVCUqQ1NNGFlVs?=
 =?us-ascii?Q?QcBHd5TL5u2Pre+QmoQd1MtSGReL+bK571ndwSo6YPbXqhtkm/XI3+Ju58e9?=
 =?us-ascii?Q?GKKKYJz4g/nXsV6swDLZoSpLIBx8iqjwUw3kqCu+swgIwjXBWQtTk4Itlamd?=
 =?us-ascii?Q?PsyM+ZChKzdWD6reJnb6rwfic23dXt8k3vgu83ogzYTbM+teCGEq99b076vK?=
 =?us-ascii?Q?wKGm4CX8pwQcIUy4TURa3Xf4lA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294cecbe-542b-450d-8d33-08dbe4749805
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 18:16:02.2382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ao8Tu00s6FXlsHwu8YA1gZp1iW/uUWFoAb+80ljDadwouJOVc2ctGnj/YOCZDHXM97KG8Qtffzttqg1lAO5m8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6656
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-13_09,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311130150
X-Proofpoint-GUID: ELknQsDuILETaJeV1s9G96pURo4JG2s5
X-Proofpoint-ORIG-GUID: ELknQsDuILETaJeV1s9G96pURo4JG2s5

The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
could disable the pmu virtualization in an AMD environment.

We still see below at VM kernel side ...

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

... although we expect something like below.

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

This is because the AMD pmu does not rely on cpuid to decide if the pmu
virtualization is supported.

We introduce a new property 'pmu-cap-disabled' for KVM accel to set
KVM_PMU_CAP_DISABLE if KVM_CAP_PMU_CAPABILITY is supported. Only x86 host
is supported because currently KVM uses KVM_CAP_PMU_CAPABILITY only for
x86.

Cc: Joe Jin <joe.jin@oracle.com>
Cc: Like Xu <likexu@tencent.com>
Cc: Denis V. Lunev <den@virtuozzo.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
This is to resurrect the patch to disable PMU. I split the patchset and
send the patch to disable PMU.

Changed since v1:
  [PATCH 1/3] kvm: introduce a helper before creating the 1st vcpu
  https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/
  [PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled
  https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com/

- In version 1 we did not introduce the new property. We ioctl
  KVM_PMU_CAP_DISABLE only before the creation of the 1st vcpu. We had
  introduced a helpfer function to do this job before creating the 1st
  KVM vcpu in v1.

Changed since v2:
   https://lore.kernel.org/all/20230621013821.6874-2-dongli.zhang@oracle.com/
   Nothing. I split the patchset and send this as a single patch.


As a summary:

- Greg Kurz and Liang Yan suggested introduce the machine property to
disable the PMU (e.g., with the concern of live migration, or vCPU prop
theoretically be different for each vCPU).

- Denis V. Lunev and Like Xu preferred the method in v1 patch: to re-use
cpu->enable_pmu.

Would you please suggest if we may go via v1 (re-use cpu->enable_pmu) or
v2 (to introduce new machine prop)


1. The v1 is to re-use cpu->enable_pmu. It disables KVM_PMU_CAP_DISABLE
when creating the 1st vCPU. We may use the vCPU id or (current_cpu ==
first_cpu) to check when it is the 1st vCPU creation.

The benefit is that the QEMU user (e.g., libvirt will not require much
change).

2. The v2 is to introduce the new machine property as in this patch.

The benefit: the 'pmu' is to configure cpuid, while KVM_PMU_CAP_DISABLE
is a different KVM feature. They are orthogonal features.

Perhaps there is another option to sum both v1 and v2 together ...


Perhaps the maintainer can help make decision on that :)

Thank you very much!


 accel/kvm/kvm-all.c      |  1 +
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          |  7 ++++++
 target/i386/kvm/kvm.c    | 46 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e39a810a4e..4acc5bdcc8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3619,6 +3619,7 @@ static void kvm_accel_instance_init(Object *obj)
     s->xen_version = 0;
     s->xen_gnttab_max_frames = 64;
     s->xen_evtchn_max_pirq = 256;
+    s->pmu_cap_disabled = false;
 }
 
 /**
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index fd846394be..b7c0c6ffee 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -120,6 +120,7 @@ struct KVMState
     uint32_t xen_caps;
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
+    bool pmu_cap_disabled;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index 42fd09e4de..7fe201e41c 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -188,6 +188,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
+    "                pmu-cap-disabled=true|false (disable KVM_CAP_PMU_CAPABILITY, x86 only, default false)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
@@ -269,6 +270,12 @@ SRST
         open up for a specified of time (i.e. notify-window).
         Default: notify-vmexit=run,notify-window=0.
 
+    ``pmu-cap-disabled=true|false``
+        When the KVM accelerator is used, it controls whether to disable the
+        KVM_CAP_PMU_CAPABILITY via KVM_PMU_CAP_DISABLE. When disabled, the
+        PMU virtualization is disabled at the KVM module side. This is for
+        x86 host only.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11b8177eff..f59fee396d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -138,6 +138,7 @@ static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
+static bool has_pmu_cap;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2713,6 +2714,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
+    if (s->pmu_cap_disabled) {
+        if (has_pmu_cap) {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
+                                    KVM_PMU_CAP_DISABLE);
+            if (ret < 0) {
+                s->pmu_cap_disabled = false;
+                error_report("kvm: Failed to disable pmu cap: %s",
+                             strerror(-ret));
+            }
+        } else {
+            s->pmu_cap_disabled = false;
+            error_report("kvm: KVM_CAP_PMU_CAPABILITY is not supported");
+        }
+    }
+
     return 0;
 }
 
@@ -5772,6 +5790,28 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
     s->xen_evtchn_max_pirq = value;
 }
 
+static void kvm_set_pmu_cap_disabled(Object *obj, Visitor *v,
+                                     const char *name, void *opaque,
+                                     Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    bool pmu_cap_disabled;
+    Error *error = NULL;
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
+        return;
+    }
+
+    visit_type_bool(v, name, &pmu_cap_disabled, &error);
+    if (error) {
+        error_propagate(errp, error);
+        return;
+    }
+
+    s->pmu_cap_disabled = pmu_cap_disabled;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
@@ -5811,6 +5851,12 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
                               NULL, NULL);
     object_class_property_set_description(oc, "xen-evtchn-max-pirq",
                                           "Maximum number of Xen PIRQs");
+
+    object_class_property_add(oc, "pmu-cap-disabled", "bool",
+                              NULL, kvm_set_pmu_cap_disabled,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "pmu-cap-disabled",
+                                          "Disable KVM_CAP_PMU_CAPABILITY");
 }
 
 void kvm_set_max_apic_id(uint32_t max_apic_id)
-- 
2.34.1


