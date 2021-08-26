Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942823F90B9
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbhHZW2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:11 -0400
Received: from mail-bn8nam12hn2225.outbound.protection.outlook.com ([52.100.165.225]:62433
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243803AbhHZW2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbZ3NrtFQ7Wk5JNP7CPFkUw0IXKop9lNQNIMwujIfzbxjDpB5V0NwgcQmFqz+O0Ys/dsgi3RM3kgou5ZwOJTtDZT3YOZmta0D76xXWPfkpvv10JTRzZSnZEwW11cqlfUgpb1ivECn4ujtSaBMwxP37Hzlr43DHOx7xzr60a+F7bOQBLY4wyQUgIhLsDf4DeM3w6MfwRNWdwffXTmI+3I5119AU7YL9vM89kESlqb8WVeIChcSZ1WTpXJVOYMzCk9Nll4xiye96RQuXoJ4UYVm2FkzhGBto10Xg389HoGspK8vqTIHwyzglG2d8bLI3i6Ctf/tVFZ8BR1rus+cSJRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGOaVQyXWHuhYSZBWyGLMbnBCq0lUcxi4COaTlsEpoI=;
 b=k2AW/XN4EiGv1yGgw6nhqzhuWABg05pFWJ9I6Flgf/hYmtYoXsspWE/rSBxSYSe1WvmSH+UPDQL8g/OugXQHXWI8vHI7a7Qfd+FLIY4YrnWFZPfGha2KhOJ7Oly0/DYtVAM3NsRyovEwmnJsMx5DDh+hJWBFvkZ7R+7myqavv3lnsJ6ztosb8DAEHcU2V8Ua7oyQOcYfQAvwTTTm/NFPZUFlbbI5PTw51qQEdnmUm39chDN/qb1M5NaCZe3+1wXl81xATNW22jiRaO3iRJkGDl08AVZVAt0kI0B4oTofm99WQh5ZCmhbp0W0ryZCVwvWTuFVI5UCc5472AR7KYrSig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGOaVQyXWHuhYSZBWyGLMbnBCq0lUcxi4COaTlsEpoI=;
 b=WF+2omRqCRikcEirzQ/DQlshAa++PspZmh9mfKjQYLNAx7+vlsuOsTbsAXjSK9qQ8kekGuaA+KVx1WfkpXSi7E2d1f3+mEnEi0cnvcJjmtq9TUz/S+D2gN+Cp5/YdGrLqAGb6rJm8JASkQmJxSFm11S3vdU/wfjCYjGGPV1qjZ8=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:21 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:21 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 04/12] i386/sev: initialize SNP context
Date:   Thu, 26 Aug 2021 17:26:19 -0500
Message-Id: <20210826222627.3556-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::30) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA9P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 26 Aug 2021 22:27:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 780a0e95-bb2e-4276-f50b-08d968e0abf2
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB392566DF33127FCC00EE636B95C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pR1nxYD4FHyYvHD00jVwcGsdMSHgbOz2oQx3t8BpQUafM0YsT8dluCL7pEMJ?=
 =?us-ascii?Q?MKKb0PZretGw1rMsERpXIcyuSDqbQAiWv5KeGWp4/qsN8VJKbq7kJIOsSTio?=
 =?us-ascii?Q?CasFfwNbeq/PBE/r14Kw4cQkBU0bB7uaFq3eak4xY+M49cx9a2Rf0l1Z7wNN?=
 =?us-ascii?Q?uy2X1mXa4UoLW1/5NiqErEl8SHvOpqPY+pKsuZbZCPoGFmfnLfD/xXfWdRSe?=
 =?us-ascii?Q?N5Ehval2WhztKwU8uc4TIlNe55ksxW2YhqmkAPoVanM5zQw+vvNNSzHI8y3E?=
 =?us-ascii?Q?K+TIDBSyUkziqMgofy16WNprM/HIV61Rk7oNfUSBKzf0IWWF/lWpp7kDLFp/?=
 =?us-ascii?Q?OjXRAJI1AIRTSmyQQg8+Xn5136fknp3lNogLvNDN2rqDqsR+U3vpe4KxsdwQ?=
 =?us-ascii?Q?kqArAz0zkOedyGfCXq9Rqz3r/PHPmSyYry4oR3y09Z9QCjMjK+rSHMajR5Zi?=
 =?us-ascii?Q?WnKYr810SNMfYAShrT8nJlTamR53lteHGuBSlqe3/3iKDpVvScCWaUk6uJ+h?=
 =?us-ascii?Q?uO7OjjuVI4/UxOeKZ9aZGh1klHUREndXNlCO8fDwP/xURsiUOpDfHKHVaI2H?=
 =?us-ascii?Q?37TECn2ZVAc/J+wtTPOPcw3/GePVDlb5uVdnu1pt7CfsTAPgSMRY+Q8dleUv?=
 =?us-ascii?Q?r2e2Mf336cKL3SY62D2tuLEUBmaEgTWURypv5+PGbtX8Ank0YtyQEBhgvSdv?=
 =?us-ascii?Q?91N7SiIKW5g6w1mQEWB4WRn0i8GRhD9e8p4JZvJmVeISWfHRj4SGkxPVzWQZ?=
 =?us-ascii?Q?dHQRUfAJbTwY/cNKVB79I8tk5bIBzVhwCOwRXJD+plsgDhGAN8X3bO/Hqx/t?=
 =?us-ascii?Q?KhFxmiqZxDkAPxCCYt1QLGWJkf9NVym6aHjLqO1cu1jm6lsy/cUfuNAJWkz8?=
 =?us-ascii?Q?ynEofXni1jbxJnDciTjLpZzLLWtKVAUspTWA+MVT2mFovZkkR6IvKjaY04Vu?=
 =?us-ascii?Q?Lhc7eNGWeDo9RULZ/WwdpwaeKfhbvdsmE58kEYSM2wd5Sa1ozB0cOJXxm57n?=
 =?us-ascii?Q?/yYiRNNasqniMo6DE94zT2OphS1bFptrRc3RQ1FUyW0caF0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cutcjVguLGaf74HaP61tZm2cuZSVxgA68vNqSH+QqZGZzNEN0lDfi+K7SY0D?=
 =?us-ascii?Q?MeQvm2w6NTKZlBEeDH2Mhrtn9Y3W6aSiSufwihQX+eG9vv7H5wsxoVaty/ei?=
 =?us-ascii?Q?/M9NPcPL6ZJorzcMRAUL2srvRXGldHRsi77XeLng5BK6OTJRVSdX6Q7VCNnO?=
 =?us-ascii?Q?wNeyQTabqKgnz27hQlttqehKHoMMds4Id4PzdylH64cWyIHN2fiZfAYIOcGH?=
 =?us-ascii?Q?9Igx7CKP+AjxDhK5vKSh9+7VGbL5qevcKlOFQuq5GN55DP2yKc40b+QHYC2i?=
 =?us-ascii?Q?m5i7DNfglq2BVCATvBnZVeDorCIB4HqRLuPJD+gZXa+HIovCO1/L3bdxGgOi?=
 =?us-ascii?Q?PfeDE88NAjkZnuIsFOfaLb/QOG2IXjFwQOaR58JDtIqrCHHK/+hwcxhU03/w?=
 =?us-ascii?Q?hKIhrnDK679lTFyQcg/jLpZjDNWW9o6cHwI7hAZZNjIeEHPyHjndc2li0wSN?=
 =?us-ascii?Q?jzNNOVMBDgJje7V9MUjupr/m0tRX0kjEQgNfjEwB8JiwMK2lNo1WsW+VOQ/O?=
 =?us-ascii?Q?xXiTfEMTuu+Hyw9bnL6i4RWvAIFWSpao6M1xNLEjU8MTd5p4lWNEPCfkopF2?=
 =?us-ascii?Q?dLW1eyidj0fnEbazj8mQBskPSnimhKmg9jtBI+YAtxgzbmNEffcE4RnVONhR?=
 =?us-ascii?Q?svoZeoE5C8B25NNDCadWPgsvdI7oI2AkSbcteNksN2ChEcYrNdB9oZNZ2HxH?=
 =?us-ascii?Q?DsOl3PNRzWHS/Ecd8PqZBnwrTvuJa75YLwsww2KOpcCormiv5UcuF2MeG7J1?=
 =?us-ascii?Q?3vbdxeuUMzglxzyUnFWx1BbzvglIDay2WNqynAoaXwIwDxu6Dr48RgSWgzjE?=
 =?us-ascii?Q?hBWaGYWQaGftUtBiUH1bO2ZDTkQtF3FAQpH0ijGzNTbxqT2zohEI+vCbDDJH?=
 =?us-ascii?Q?DN6bM2ov5w0XnUtAgUxT9ufSm1QNujHN5MOw22xQ38tDWAE6pKatH2OWjlc+?=
 =?us-ascii?Q?fNtUbSn8RoYumduzsE7HP51LpwUS8Uuaei5u3QY8YvsmfHJZZL5Vh0l4Pfus?=
 =?us-ascii?Q?xNzA+AR6VioFo2bR//4Ocyan63c0pk978uj9Goc2ZiQV/JZ7O0FfTnYxc0HI?=
 =?us-ascii?Q?aVGwOuRjTuAXNzeR521Lg26HPKobSzuiGQ4gBofsBlToveuDefQxHF0L7HrA?=
 =?us-ascii?Q?ZswqP6AUS7/UXd8e6flRDJqAzpHWTYk9YzvUha63u1wy5AgTf630MwlaQuEJ?=
 =?us-ascii?Q?Rioayml+w+isSWqKSPoInoSapyTKEHO/eXzSpe3hZOLpWdCZJKOsM9+NqxoH?=
 =?us-ascii?Q?7Cm4msWcQuVwRh11dj+hgCHE/o+9GAl48x7Dnk3cPnlrWYGswmlC6IKCAfYb?=
 =?us-ascii?Q?TI+C2P4oKLkhVHBJdXpSp7FY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780a0e95-bb2e-4276-f50b-08d968e0abf2
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:21.7510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jpCMxidO7h9pcpryJJ8f5CLPyOCCKk7X+FUdfo/64cwKO8M0uvHtPkKvkH2s6U9nDWm1+30Nuhkd+krU5YiT/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled, the KVM_SNP_INIT command is used to initialize
the platform. The command checks whether SNP is enabled in the KVM, if
enabled then it allocates a new ASID from the SNP pool and calls the
firmware to initialize the all the resources.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev-stub.c |  6 ++++++
 target/i386/sev.c      | 27 ++++++++++++++++++++++++---
 target/i386/sev_i386.h |  1 +
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 0227cb5177..e4fb8e882e 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -81,3 +81,9 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
+
+bool
+sev_snp_enabled(void)
+{
+    return false;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index ba08b7d3ab..b8bd6ed9ea 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -614,12 +614,21 @@ sev_enabled(void)
     return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
 }
 
+bool
+sev_snp_enabled(void)
+{
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_SNP_GUEST);
+}
+
 bool
 sev_es_enabled(void)
 {
     ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
 
-    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
+    return sev_snp_enabled() ||
+            (sev_enabled() && SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
 }
 
 uint64_t
@@ -1074,6 +1083,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    void *init_args = NULL;
 
     if (!sev_common) {
         return 0;
@@ -1126,7 +1136,18 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     sev_common->api_major = status.api_major;
     sev_common->api_minor = status.api_minor;
 
-    if (sev_es_enabled()) {
+    if (sev_snp_enabled()) {
+        SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
+        if (!kvm_kernel_irqchip_allowed()) {
+            error_report("%s: SEV-SNP guests require in-kernel irqchip support",
+                         __func__);
+            goto err;
+        }
+
+        cmd = KVM_SEV_SNP_INIT;
+        init_args = (void *)&sev_snp_guest->kvm_init_conf;
+
+    } else if (sev_es_enabled()) {
         if (!kvm_kernel_irqchip_allowed()) {
             error_report("%s: SEV-ES guests require in-kernel irqchip support",
                          __func__);
@@ -1145,7 +1166,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
+    ret = sev_ioctl(sev_common->sev_fd, cmd, init_args, &fw_error);
     if (ret) {
         error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
                    __func__, ret, fw_error, fw_error_to_str(fw_error));
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index ae6d840478..e0e1a599be 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -29,6 +29,7 @@
 #define SEV_POLICY_SEV          0x20
 
 extern bool sev_es_enabled(void);
+extern bool sev_snp_enabled(void);
 extern uint64_t sev_get_me_mask(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
-- 
2.25.1

