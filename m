Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3913F2578
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 05:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhHTEA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 00:00:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64116 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhHTEA2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 00:00:28 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17K3uWrC028993;
        Fri, 20 Aug 2021 03:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fUh/EuflnkJNVlsXuCYfUBu41bKOMvMU+mXhbO8brsg=;
 b=srBjCx1869Dz391aIS30LCb5C9HfH42YAIUUeheLXCRl56zUArmxmOueJWK/SHsZdFCF
 9OWnBQtptUKvu3NaVCFPaTQHYTzPoPqL5UvitTnthRkzhDGZmfM4zIoTSFo+MfSyxa3V
 qKV5YRDZ6K/16/XiCmyc8OUv2NorfQKfPU4nkSDnmC5dh/bF4rjLqmUu+pgtjormeKsR
 7IiAcRLMCP0qdwg4C67qMjzX/fDtSioxHW6gMTXEHzQcy3tXarOCBYnVkbPmH/Yb6oqE
 bARooPkA9P14xTt/g0YKR3sh1RkLXX0va7kthQo/wMBypH+WIkQGPHpwHnNBwCBAwAA8 yQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fUh/EuflnkJNVlsXuCYfUBu41bKOMvMU+mXhbO8brsg=;
 b=M6BLVjaOd5Wnr+F2gRTF3NXFr9BYjXgCdcCNg9rHAGhANh8k1z9D+vsKDNT4NjPikcUL
 Vz8aZ8aIxo3bQdQV89z+TSVBBCJEPsChXNonPx9OEYAJ38KFCGE1WWtnZhE5JwVy9Ur7
 tCZIyrvu6nrJy5qmyTTDYpP0nkh3sv9vDbo6CKnT5XbFz5WBLCq/64Y2USl63IQ3uxm/
 ZisgVhjqRYnnkxGLCLioRZZVkJTu2Nfdjd6oRHfzNQ9jozmqS5kLefbCH38NxNSLgewL
 2YBoZupVYZM47oHo8Z3jBl3gIXJf29UCayaSML8zDgRVP8RbStfVPJRI5b8YQa06oqAF Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3agu24neeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 03:59:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17K3t3B1133821;
        Fri, 20 Aug 2021 03:59:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 3ae3vmsx44-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 03:59:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dq7F0B3Pk/G8s9hqN98ftuBtUZ1ZEz2agOFa3YhJRQYMxlGsytQqznZbHf2+3A4cfvNrT5Zsj2w9fo4rMvkVSiBW/mUEqjR8xft2SsMvjhZIc4gqo7Q++u5/oN1fudAER272WgClAKqJON59eQOUJCdn+Bi7havLGUbd9xJGzcx8AE1wX+SpC0mv8SbmU6V/0IAH6vjtgK5puEmCMTu7abXAEc73bg2QDr9CZyBlKTNWTnvPYXaBXQGBBRWt/2rxUJAzsxf+LGYKer4XzGZExTdh2/JPAMzsJGnlgCaN75YaQhU3ST09e7QqbHbpx3EcfbmgwWac0QxbZbcJsf0s5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUh/EuflnkJNVlsXuCYfUBu41bKOMvMU+mXhbO8brsg=;
 b=AzqFeKxDUU4aexlg1YbP8WIZJooo6mviC02E0EuCEHvceo3yUvuMmm6+rTVLTAtvPDhitDWGvZRuM7IzF7z7piSRWhe8avPfWB4LU1ksnF/sWF/+CSxaq0Vh1ynA1S6/oAeDC5OYmvYfJfRME/7Nj0YztwnXe0CgaIjTENuVhbPtmi2OyrdcDvJ5NwF2c/S0mShi9l8dmkQMUbFHm9nRFpnv4YteVxhleeofn9cIHYTtVk4W7epvZ1d14/ejs0H3e+/TTuCpkbtd8S7RavUZr0y9th9PcpvkBVbfyjBX+KOB/SnerHtDBLqI4wqFa+xj7/s5W4y0QktOp6tTnjqQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUh/EuflnkJNVlsXuCYfUBu41bKOMvMU+mXhbO8brsg=;
 b=KsRfSToXYIL8ArJCuV1omxKCRD5mcz8bSMx9m5Tefq+lK/XBoDauatlejelwiJksD66S00oFVu5o5bijyI0BpdMNFDOYTm/xnSrR9+G0xN46YlQFiXMIvniKqi6X7IqfCuWFD5QkPH1DwGGS7dPXVfkX7PPFVO5GTQIyp5hYeTE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2512.namprd10.prod.outlook.com (2603:10b6:805:47::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 03:59:09 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226%5]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 03:59:09 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH v2 1/1] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints
Date:   Thu, 19 Aug 2021 23:05:20 -0400
Message-Id: <20210820030520.46887-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210820030520.46887-1-krish.sadhukhan@oracle.com>
References: <20210820030520.46887-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:a03:33a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 03:59:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33680dc1-0380-42e5-61bf-08d9638edcef
X-MS-TrafficTypeDiagnostic: SN6PR10MB2512:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2512517FDE2029D6A2541E3781C19@SN6PR10MB2512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: USddI8mDKsxoyca6JF1Jsoqa0dtdEZ0kRHFaUHcZQjUj+hvu5xFSLShsVEnlsgWQywVwK1/E8oI7+WujsnlAAtT8bH4wBZ2TyIs7KqW9L8G1jHjt2Q+x0OZ52YV8wgX9G7+z78x8/RLv5fmYssTJynUF0AiAvkqMCIC0o35vKa1ujhXSe9afH0ck31f05kD5jTqnztwppXjmzF2hCIlaYPhw/z23HA01ZQGjvo7tBzKqK+OCVJld9l8lcQPPEfd883b3OUNjX8BMrOHuZUkqt5WID2oRmWy1hYuZQAiFUDf+CTHy6Ozl0/ZUoU3wBoIdPCenAn5qx8JlQjxZtLEOs/9yWFbMJc4dQtRGqybD/dSm5B6XCwigaB4RK8HpaBZBdTp0GPVG3jNgjwv9GQc4/zoh9nIAVvKRPvt5gnzkhCy8E74NIdy8mcrBlEdyrBNZp8oGFnXtYR51l63Yplk6W0YFY/Xrzh7IROAiuMWOQ6Rg/aJohxTPmzRGG2s/huVAThe9b/UcSt0WLNB7l2PVBKFnePxACKfW06EWQ/MJ50BfwKE3T16oJIN5U5x4XYs17dCZMjv13TWTjFIaT5Q/J5Fvzy8kIAJmQNjsMFUflMPYqCV/sU918SRtcVdH8+Y8HT0H3hBdWFkuWdZ6+Bx8jXvgtzN8EeQqpX0J7UcJRKBZVnBpVqenh9uv9Fk7HH7JQN+NU6qFb08YE2Vqt/lTvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(2616005)(478600001)(38100700002)(44832011)(66476007)(86362001)(956004)(4326008)(2906002)(38350700002)(6486002)(83380400001)(8676002)(6666004)(66946007)(1076003)(8936002)(26005)(186003)(316002)(7696005)(52116002)(36756003)(6916009)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mtoWxZ6Htiu7Qfq9Vcuy6nZgmd5I40KyknGQ63KwO8yemn4YHlV750MBFmkB?=
 =?us-ascii?Q?erWO6SAxYwIq2h/aAr5P1lOuuyjYlu9sjgTLBtaBfTkYATjggvuIB3MuFU3l?=
 =?us-ascii?Q?rXFSKI2qkR+GwirOEF/FbrEm4AeICqmAD1rXMSA8a/O+OCG0O3otG/ZW1Leu?=
 =?us-ascii?Q?ztZaReDnOx6lXUJS+m4bn0mjeRegqmbqLGgQox0749fapAXatOKlrsM5njlD?=
 =?us-ascii?Q?iZ6SEsegAt7aG+Czs6VoN3tIxjODvhCEXGwtkBewFTioWMr9ayYxTutZ04GQ?=
 =?us-ascii?Q?hAz5f3IrGbxQnDGZ6DvTnC2rdQC3Y+3p67d7kPNt7Puk1rPHx6K4pn6vMz2+?=
 =?us-ascii?Q?ZVdyW0YMfhnguT9Vt4zyFc1Y4Cd6ID8QIKVgAmb7TIQ+v6NLXgPC2ZeAy9I0?=
 =?us-ascii?Q?UFyXLlWxbfFfBdV0rYD/nVwF1EEazcU2ek5EG3f17ocIKhNlxBPC4XHjEkrh?=
 =?us-ascii?Q?SoXzrg5WZf3UyNXkI+rttV7yWqPocJVNG3r2IkOLfZsDbrczjieDTgGBxF94?=
 =?us-ascii?Q?c2UvT6vlJZJ7iDDwGtr4r8a0AhJJRKONj6eQc/7w17+ez/WuwOb26R23BJ5C?=
 =?us-ascii?Q?WV11Q+yZ1EvxFDh/PwB+9elf2Mvagqzx6DQQhraDEW6MyVwe0hL/CN5do0kl?=
 =?us-ascii?Q?ctZHn27G4iO2C6BLa7rUyRq71kByJ5J4IklDayJvwHEZsHES4bZYvzVFUNaG?=
 =?us-ascii?Q?rq8xSKv0vRXmJrfhKhkFLv6sgKJwSSLAYtTFcrKW4y+rihHkuYvvkE1ShOss?=
 =?us-ascii?Q?/5l2xoRRWYM73GlMpTdGLm5qIQBDmioAT/LnCOvdtU0eWb1+4DyVG+FdjqK2?=
 =?us-ascii?Q?lv6+gFiS5OeYT+tkfrq2/+iYKy8ga6MOHD65ocazhHLT1D4sEE+6XQcbCVfm?=
 =?us-ascii?Q?I1+mAlfNAA0wEixhGtMgh59WPzWnCcqyXOjqFSyIhEUtj4Ujb89Qd4vBkp9j?=
 =?us-ascii?Q?iKxMFE+V+dCIwOwm9yaXkX7d5ugtIXohOV6dILu2hIY85/YFpo5QbUUHbdx4?=
 =?us-ascii?Q?4clrY0MFlAm4J8Xsnc2/VT072GYBbn4fSQVOy4oA+JESh+bij5UQICcyhUdm?=
 =?us-ascii?Q?BBt0H9trA+9+tjn6UmUmi3/mMAKeZt8nnsB5pLCBlG7laUvAScgHdR6iwc0v?=
 =?us-ascii?Q?1emrtSaB76o6sU6hoQEbguXpH6ycY8tFik1nzjIT4kzeAmNY+fjmvKRw4fxm?=
 =?us-ascii?Q?s2U3UvltZsK27e+pKsZJb3BtuFb2lmDwOt5yHxTaiV6w8iZRpMhsexmLaDIe?=
 =?us-ascii?Q?ajTlUtocsvaL0XCCOGpGwTrdbH4tcX4DVsn0K6T6zrWU70bGdmBKJ9NZ9sZU?=
 =?us-ascii?Q?RQEkTAnzfFW1YcGzugQm/Ezh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33680dc1-0380-42e5-61bf-08d9638edcef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 03:59:09.4986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6ExGphaZN11R4Wg3AQRS8zRt3NtUo+BOXs/RdgQgV4OrVm8CwQJGeaFTgYUOPdZP7iq5iytiNciMgeDGPmjmYVWDaVMjh69qYFhYdh8kUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2512
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200019
X-Proofpoint-GUID: DCsbwIpgRlptNH4Weq6cBi7n8UiHN-u3
X-Proofpoint-ORIG-GUID: DCsbwIpgRlptNH4Weq6cBi7n8UiHN-u3
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From debugging point of view, KVM entry and exit tracepoints are important
in that they indicate when a guest starts and exits. When L1 runs L2, there
is no way we can determine from KVM tracing when L1 starts/exits and when
L2 starts/exits as there is no marker in place today in those tracepoints.
Therefore, showing guest mode in the entry and exit tracepoints
will make debugging much easier.
With this patch KVM entry and exit tracepoints will show "nested" if the
vCPU is running a nested guest.

Signed-off-by: Krish Sdhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/trace.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 03ebe368333e..091415870ae2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -21,14 +21,17 @@ TRACE_EVENT(kvm_entry,
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
+		__field(        bool,           nested		)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
+		__entry->nested		= is_guest_mode(vcpu);
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
+	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id,
+		  __entry->rip, __entry->nested ? ", (nested)" : "")
 );
 
 /*
@@ -300,6 +303,7 @@ TRACE_EVENT(name,							     \
 		__field(	u32,	        intr_info	)	     \
 		__field(	u32,	        error_code	)	     \
 		__field(	unsigned int,	vcpu_id         )	     \
+		__field(        bool,           nested		)	     \
 	),								     \
 									     \
 	TP_fast_assign(							     \
@@ -310,15 +314,17 @@ TRACE_EVENT(name,							     \
 		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
 					  &__entry->info2,		     \
 					  &__entry->intr_info,		     \
-					  &__entry->error_code);	     \
+					  &__entry->error_code),	     \
+		  __entry->nested	= is_guest_mode(vcpu);		     \
 	),								     \
 									     \
 	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
-		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
-		  __entry->vcpu_id,					     \
+		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "	     \
+		  "%s", __entry->vcpu_id,				     \
 		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
 		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
-		  __entry->intr_info, __entry->error_code)		     \
+		  __entry->intr_info, __entry->error_code,                   \
+		  __entry->nested ? "(nested)" : "")      		     \
 )
 
 /*
-- 
2.18.4

