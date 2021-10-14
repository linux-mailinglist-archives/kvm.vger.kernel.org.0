Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BF342D947
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhJNM3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:29:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31690 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231618AbhJNM27 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:28:59 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EBBG12007394;
        Thu, 14 Oct 2021 12:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=fTuH0e+vanhHdA8p6E+eGGHXIdDBbd+CzQLqewVswOw=;
 b=aY+5Ns4Uh3I6RUvoTV6LY9UfEzZgquY2RN/Z09Ku5e/Of5B94UcyxiMM7UBXdccuVMii
 +niqpeYQt5g3JFpix2wOVvfsNqyZiOjIFHB68ljB53xoygGTsy/Agl5GrLJCdj4cdttq
 U/3gMVfWu4c7MVPOuiVsaUj45tqjAGNOIygALQw28n0cNA/jijf4gpilVUM1qmb4q/an
 YLlt/IIT0lVDtphqNjGfI1XtUhpLJ/wsqCJgf5OPasg5jE71UC4CRicTNABkZPd5wGk8
 hY8/lHlIzMwDF9Q85ePVq9U4c0KOqdQwyLW0TZqmFKmC586nCm74fGzCPrfTBpN8jzjz 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bpfsyhr79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 12:26:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19ECKq7k007756;
        Thu, 14 Oct 2021 12:26:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 3bmae2fp01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 12:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmkyjgYdEosQE/vtdLl+AmHykIIvgrCjO6hPjdAYnA6hg6xNLVqbi8Zav+Eroh3PGxux7Y5JZYh8EdaHhur0jxE8RB0nVUnvJspCDuBOFrEK5k9GFIBPjXjXGBPbI6R1h9Xn34fhd2Qv6x3tHfGvoJZMZtRQQC2JpxKP2Grm+OlCCb07xBvAvrHkRQL2QvxVRY/WgLzjJpteaI8ZEpjx31DGstfIal6Aqcd/WD2IFUqOdsoMTY7BF07j7ybh5nqsn3D8K58LYmL+BNcHBt82BIkFdtEUGHqLbq+BKqHmdzZKxpJUyrKQrx4BaD/D2RnWIgJSRdl+QhoHhlPH6cjZ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTuH0e+vanhHdA8p6E+eGGHXIdDBbd+CzQLqewVswOw=;
 b=Hv+/tMVs+sxv05GrRvMQhUWXEq+4AUWrMRdnmlApElGmQzPLO4cUmJ3NAkBPgbqLij6bbS/f7J4S+hqEb0Opgx8G7Y4QZ3v2vF5K8aFSKcst/rfUwIRYNIXhm+n/HmEbuS5mzt8leT3vkrB05QewL7nMF/LOi+Dzxpnj+L6MvGMM/IqiLB6SgIEv+8wIVYiJynCRXde4h3u7Z/kbOjIcOGrf8s8OdR81q+/37k/ifAKaJGT2FBu4qb7XLoF7G4O/0UsGB0pKuqWrCwXntdRrRXEUFml9/N4q3YK4feulE4DVhNhMoAwy9Eh31hZxmtCnBJqoZHKYo38dKQgOhaeP/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTuH0e+vanhHdA8p6E+eGGHXIdDBbd+CzQLqewVswOw=;
 b=kZb73hEa5hWC31HRZR2qvEyg4AHzS93zFh66TCI+pZc7EddAwNhP4H8JD/1yar7RfIVratXrC+6fJx2/IDc0C4L/xxDl4sEjzmWBmXb0gqoSyg+50w/f33D9Yh/9tlHux9zjSU3PWUM9YR9xMJJyILQaKHGhi0n5aSkS1YrZd2Y=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2318.namprd10.prod.outlook.com
 (2603:10b6:301:2f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Thu, 14 Oct
 2021 12:26:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 12:26:49 +0000
Date:   Thu, 14 Oct 2021 15:26:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     colin.xu@intel.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
Message-ID: <20211014122638.GA1737@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.219.103.140) by ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 12:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12a80206-f2cb-401e-07a8-08d98f0de52e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2318B3C297CBC5C22AF3E5088EB89@MWHPR1001MB2318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZETkjSwpHSOvvlff2B0dZEOnJmIHJEKpdaGDoSX7zpDGCbA8OuiUhVCqF89gOPQcuvReWpX4dyAsy5rgLtF4QCJbAV/lwB3eQBZFh3z/b4Bo51oC7WsluDKvxXBsuo5DjyF4WFSyqLOUwZsh1GZ2ZCWW4DTiblzE3hTQ+u/7NQ7kWqHlHhhEERqKeqcRkiNL+TgN57FcFFR6nAZ1Iu09kYAD0260HBSPoNlGewBl/tt7AVXMOFg3mfgybBpPgZ97ErXEiozhyhsDvdVELjvGdI2JCtzd+uRMZBtqLaaD+pBQi9/ok6z5T4gmoMC2lKqmGMAUqlIkBXbXssqG/zmaA5oM1WYi0ogWHgdkh9GM7iCX5JDbfUsKtple4tcrJI4Phwp1VeLp7oRv9qk8zWWOrI5kUUEt/bda2skjkP6Dl/vZ/p9j5p/aL2Kb+BU4eK+ufvzCCWvRAl2Kp6YkSpfzee5+Xo2f5pNpTnNTc7glD5xrWC0IjvrNNKzso11xwPv486rFP+D1FoBFRNmJ8YrxmQAnbpUWhC9IpFb3IB/Ic0Em+7nmjwI4Gb32F+MgVUGB4IN3m7pbtqhTkw8yEb6OvsXYP6njFHNAE3sQzJleRVI7zrMgwANhaY5HzV6z24HcesmQlLRjqVWPPjVjmmOvCrfH+ZOMa+5hEXkLFUJKPPI5FDZgMTiATEm8YfWdpgXivFmed2R7wbDj3WEeTcj6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(366004)(6496006)(1076003)(26005)(86362001)(4326008)(9576002)(186003)(508600001)(52116002)(33656002)(66476007)(38350700002)(33716001)(38100700002)(316002)(66556008)(956004)(55016002)(5660300002)(66946007)(44832011)(6916009)(83380400001)(6666004)(2906002)(9686003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8cJv2aiZxRXI9U6EIq8ga+LQyGkYDxXhNphLAeBwH3tuTWVATmflxKdeF+I6?=
 =?us-ascii?Q?AJC/HYiU0nT5c/InCnTOGz0REOE4SLuWwUkrYsg0cfbGq25BC2ubYIpm8hhL?=
 =?us-ascii?Q?uVuky+FyQ8zdBW/DB3R8FuzXLOxILaOMsJ/JCnPN9Vg747AY9YGoWvrStgQ/?=
 =?us-ascii?Q?gUXFVASH3JtXsHjaDTGlsXEI51gSE/u6JfTVOUF8nrztZ/knr/cGrINnWB7j?=
 =?us-ascii?Q?+sETpsIYTPAiClxJAyt8hQDvgPQj2b7QgHWx0UnvzISoa1kGvtVUhJ1FTu7+?=
 =?us-ascii?Q?KkkNFSF5jElVEXYEw6pYQn4Mw8czhBP3aeJ1Frey8N2J1RvxsL921Ev5sTxz?=
 =?us-ascii?Q?vy6t6J2J0tO5GrsqqDhx7c57xqLZDixxLDvbupHI4OIm2PYsK/QApkqlsGkB?=
 =?us-ascii?Q?qsTM9z910GDFt/LjzXGrolFIqKWrXztGCP9jrRmNSBldNvKkybtB9uwPk8rc?=
 =?us-ascii?Q?aiiIp+UCiQGH33SmeC7bzkaYQ4aizN2KNlHKJNm4Z+B7zLRRZX/iIVpRu3I3?=
 =?us-ascii?Q?plYkZK05Hj98Y1ueELv+85VsJODpj7wZMlcV99eEz38QklLipr7WLg/AUmQh?=
 =?us-ascii?Q?BQwDBedoZcYygyFp5Gl0V3J98FiOch2sw6A3QLnpUuGVYlCgWB+1smoBtLmb?=
 =?us-ascii?Q?lHmR49Z/KuD67YqT9L2rFH0axzZY19fGYwZ7kWRKYOEsHAx1XjV3Lid8qjdi?=
 =?us-ascii?Q?rEhe1cfPeVoBT1ejbXUziWelGo6h+A54S+Qeuv1CjrIIKHYD//gkwsColm/Q?=
 =?us-ascii?Q?GfKj52stUJGFJUSruHKyJJFjaFo7lvh+SMTFsHWzyZ6JVKe3Xmflngrqwv0L?=
 =?us-ascii?Q?TYoez3Jcfi3Kd3mTs8EhwOObS3T0v4xt6ByQGKUdkbp7zBxKPCLSPXfbDXbQ?=
 =?us-ascii?Q?aNILSI3mev+CUUXIZjZvaL6InF3cn8vLR8wZgumF+cVRflVum+bqsfU2y3z/?=
 =?us-ascii?Q?abHyNUTg77PU6SB5HsgfxAp/sRDqTHwA739E8tzDyggj+dCFgqujZkpBUyXX?=
 =?us-ascii?Q?maK+xVXNSFMJzVHExA+32bAd57XOQIngkaJdntnVxfLp0moopET0foT0jGMO?=
 =?us-ascii?Q?pJ78S6TbnlI0jlGajVbGsNypBQ2xxhN9YsJh3PCocWLOj9fUn0k/sRzUNuIL?=
 =?us-ascii?Q?J8l4ysTft5FDlPCcYZC7i4NWLP+jlhdR94C7rg2UlXow03DNNBDsxRwmbsdG?=
 =?us-ascii?Q?a71H31VRQtSFPs5y/xVpaDkyR+GUAbdJKvkI/NQVsI5sVn1IdSCK/Mm9MqiE?=
 =?us-ascii?Q?v7qUqVeiUkZdOgXbNskXYrgILQoWM5768U8TtUeR+b+gnxlJhslFsNuFV/jb?=
 =?us-ascii?Q?ZVvtwXgT2MTqEn1UOuVb7kse?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a80206-f2cb-401e-07a8-08d98f0de52e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 12:26:49.4260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5h4Yi6gMaW0cbRpzFz7kADdfZbY36NpDRHD40DdE+d1VnbBW5E1lgZnYYRhdg0ZRLk8nh3W7FmeuSvCe98mXYaLTspjezeIETQ2xaMCuqiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2318
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140079
X-Proofpoint-ORIG-GUID: 7AX10fU8ysBG3c4aiWBxu9Mw2N4IURI0
X-Proofpoint-GUID: 7AX10fU8ysBG3c4aiWBxu9Mw2N4IURI0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Colin Xu,

The patch 49ba1a2976c8: "vfio/pci: Add OpRegion 2.0+ Extended VBT
support." from Oct 12, 2021, leads to the following Smatch static
checker warning:

	drivers/vfio/pci/vfio_pci_igd.c:101 vfio_pci_igd_rw()
	warn: potential pointer math issue ('&version' is a 16 bit pointer)

	drivers/vfio/pci/vfio_pci_igd.c:124 vfio_pci_igd_rw()
	warn: potential pointer math issue ('&rvda' is a 64 bit pointer)

drivers/vfio/pci/vfio_pci_igd.c
    64 static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
    65                                char __user *buf, size_t count, loff_t *ppos,
    66                                bool iswrite)
    67 {
    68         unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
    69         struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
    70         loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK, off = 0;
    71         size_t remaining;
    72 
    73         if (pos >= vdev->region[i].size || iswrite)
    74                 return -EINVAL;
    75 
    76         count = min_t(size_t, count, vdev->region[i].size - pos);
    77         remaining = count;
    78 
    79         /* Copy until OpRegion version */
    80         if (remaining && pos < OPREGION_VERSION) {
    81                 size_t bytes = min_t(size_t, remaining, OPREGION_VERSION - pos);
    82 
    83                 if (igd_opregion_shift_copy(buf, &off,
    84                                             opregionvbt->opregion + pos, &pos,
    85                                             &remaining, bytes))
    86                         return -EFAULT;
    87         }
    88 
    89         /* Copy patched (if necessary) OpRegion version */
    90         if (remaining && pos < OPREGION_VERSION + sizeof(__le16)) {
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The sizeof() means we know "pos" is a number of bytes.

    91                 size_t bytes = min_t(size_t, remaining,
    92                                      OPREGION_VERSION + sizeof(__le16) - pos);
    93                 __le16 version = *(__le16 *)(opregionvbt->opregion +
                       ^^^^^^^^^^^^^^
Version is a stack variable.  I think version was supposed to be a
pointer.
			u8 *v = opregionvbt->opregion + OPREGION_VERSION;
			__le16 version = *(__le16 *)v;

    94                                              OPREGION_VERSION);
    95 
    96                 /* Patch to 2.1 if OpRegion 2.0 has extended VBT */
    97                 if (le16_to_cpu(version) == 0x0200 && opregionvbt->vbt_ex)
    98                         version = cpu_to_le16(0x0201);
    99 
    100                 if (igd_opregion_shift_copy(buf, &off,
--> 101                                             &version + (pos - OPREGION_VERSION),
                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The math doesn't work because we're changing from byte units to
sizeof(version) units, but the more important question is why are we
copying stack data anyway?  :P

			if (igd_opregion_shift_copy(buf, &off,
						    p + (pos - OPREGION_VERSION),
						    &pos, &remaining, bytes))


    102                                             &pos, &remaining, bytes))
    103                         return -EFAULT;
    104         }
    105 
    106         /* Copy until RVDA */
    107         if (remaining && pos < OPREGION_RVDA) {
    108                 size_t bytes = min_t(size_t, remaining, OPREGION_RVDA - pos);
    109 
    110                 if (igd_opregion_shift_copy(buf, &off,
    111                                             opregionvbt->opregion + pos, &pos,
    112                                             &remaining, bytes))
    113                         return -EFAULT;
    114         }
    115 
    116         /* Copy modified (if necessary) RVDA */
    117         if (remaining && pos < OPREGION_RVDA + sizeof(__le64)) {
    118                 size_t bytes = min_t(size_t, remaining,
    119                                      OPREGION_RVDA + sizeof(__le64) - pos);
    120                 __le64 rvda = cpu_to_le64(opregionvbt->vbt_ex ?
    121                                           OPREGION_SIZE : 0);
    122 
    123                 if (igd_opregion_shift_copy(buf, &off,
    124                                             &rvda + (pos - OPREGION_RVDA),


Same thing here.  The pointer math is wrong and copying stack data is
wrong too.

    125                                             &pos, &remaining, bytes))
    126                         return -EFAULT;
    127         }
    128 
    129         /* Copy the rest of OpRegion */
    130         if (remaining && pos < OPREGION_SIZE) {
    131                 size_t bytes = min_t(size_t, remaining, OPREGION_SIZE - pos);
    132 
    133                 if (igd_opregion_shift_copy(buf, &off,
    134                                             opregionvbt->opregion + pos, &pos,
    135                                             &remaining, bytes))
    136                         return -EFAULT;
    137         }
    138 
    139         /* Copy extended VBT if exists */
    140         if (remaining &&
    141             copy_to_user(buf + off, opregionvbt->vbt_ex + (pos - OPREGION_SIZE),
    142                          remaining))
    143                 return -EFAULT;
    144 
    145         *ppos += count;
    146 
    147         return count;
    148 }

regards,
dan carpenter
