Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA93ED772
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbhHPNdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:33:19 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:38848
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240692AbhHPNbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:31:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKZYJUjzjhB5Tm1CJvDOAlcDszBgKx43dhglBETbS7ScDpIBtUEP+5xhVxWOJdPcpJooswExyv1FstHDU5nsjDagq59hRbjVatrPrxpHjPb0tvlMROe5db37fn8o415c3+hkwO0YProd2pIYJh3fooP6tUZTf1CzosN/e2zxJoMROsBqGoqGPKjjcgPx240iNEbqrSs9nTejRcGMat+R4EoWKlqBy9YcnO04uuIl6ZyAAbB5JKfOiekZP6E96yfrKS7+noU/+setzY1Zbs3p0Oam+ev6nIpqplev/cYz+E85N3zbHlX6w+0wQ0zpxOY7qcswKOjMIhHkhk3RZqvmKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMN02OwUC7b5/wEDyb6xoGxpcr39mOZrwuq92xQgBEo=;
 b=hEoHCxzx+dyrMVbYgjFAmtgAsJi6WTiwjGlgyaWdUsFUv3t1DOWxO9usNpzAZ8QLFfPgWVNRBDMZcaWHZ42jc3EhUSLZnzHWpf8IIwKBlsRN+f+7U8r3Q4dwJRoLMtibSIbuDud3HQVyUlyF5wg9VooZYP1aQGh54ePkElSHThisjbS460pFhJ5B54eavwe+o6+egWMtOAJGefcUuR/miMbHcKPV0n+XVBK6C/IXASBgIzF6AmqwDS27HDD6aGZoD2N9wyqErNeMlIrt0pxaDbcQbrcvEvvVBVUh5lvnVCwp1euZfM78CNYEWUcE+ZHZcnYFPwTuOjx0uYtZ4qw8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMN02OwUC7b5/wEDyb6xoGxpcr39mOZrwuq92xQgBEo=;
 b=PqEp1IlgCZXkJd403YpHSNBt92X2CyOFryS3n+QwDvh5RPCo3DV27/K/az8iAnXeq/zbdss9qLrTgEvYrnmWzJ2AqU9eK24UrZXw67AdaEu3NxvLbzJelEqQAai7/oL24nWagtjChgXMEiGVDzq/UBWEENaFxWsitHPouaEwqQA=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:30:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:30:09 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 09/13] kvm: create Mirror VM and share primary VM's encryption context.
Date:   Mon, 16 Aug 2021 13:29:58 +0000
Message-Id: <0818aea436a5b1a0dd86535b15349137dad73308.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR05CA0011.namprd05.prod.outlook.com (2603:10b6:805:de::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 13:30:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb371585-84af-49c7-b1e2-08d960b9f7dc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB451227D5D088D909BF07E5E38EFD9@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t0I5rQtk/HbbfkHuHJYrfq0xHQBd2LrVi7yDKND2uSdh//rS6scmgzK2d1cj5QHcYScijQ8KrTR522W6G9SmLwvZrNnigVbk+8xWVLZJeHyGfhqwmmdyiMJuq4n9Ke+UKktYrLD1fy3R16lKp7sBeYBHsTYpDw/1DVeT6oF7h6HDu4SzUQbPhgdRCZSIudhOsuIvqcmygOoQ+ZNBtJnxUmwsy4eQSG6vLTflbuQAnS5RvJEVxLqtHAfbCJuCK+0mQtAKoHRJxOqZLrHcqpiWpjC9BCqVZYb4W078bGlTV15JTtXlPn5tvow0GvPW6c+TFM0OeOwjnfKTdYhrIVUscNqmUsQNBB04UxzD5qI06pTsVHRJvUeDTM0TYmp89I+voukEMAcAFWtZRQeJhksAwuHkiRi0+2wttpB/+fbxgfSpUc3qw+RKVjUHKPCUMd+re/us2qRyfiqs7QEs2nEkwVgnY+enGnOHMzLHZ3ZFgc0G82nGMILsvRpRvr9yCGVEjmnyzZPc8CGx6yaXlov7QNht6mkLiEK+uiXZYII+Y10YRWwQZ9MghkJN37IUSx8iJFkZ2xRu/UpOvCACH2HQprvOqcLCv4/YiA1Bqx2cJ5U/9Hj/6d+p9pm+J5lKXi4Ry+9JdsyYgLMOnuMLbPyjBzlGyeKP4wSEQtRivOJcpZAEnOwy+Yx7gRVz24Z7q6RzQrIZH5h6IkuBAvzgpTlMRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(6486002)(7696005)(478600001)(36756003)(52116002)(38350700002)(26005)(66946007)(66476007)(186003)(86362001)(316002)(38100700002)(66556008)(2616005)(7416002)(6666004)(8676002)(6916009)(4326008)(2906002)(5660300002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fl9KVjsskxhXOPvNXBnoBnzvtkE7KOh3QvR9+NK/3jOEPklshAy3XAa3pZ90?=
 =?us-ascii?Q?Bst+yi0auaRSyfdVS3TYsdUP9eMzryMIFHzIeCwKTgAJAOQ2Rr+ABnVlfY/4?=
 =?us-ascii?Q?np6Ma49TY8sZFbb8SWERk6ZXyhmv1YTOmLdHf4mBvW95U4Us3raeSgd6qY3O?=
 =?us-ascii?Q?cqVx8wdt0WOT6BAgsW13+XRC+zn2GNy3ZXwcPZ9kdIajvBwFGl5u09U/rP9D?=
 =?us-ascii?Q?i2QsDRDzAiAGXIcn2fi7O4HulKm9Jb0GCJEPX6FbVun4IBc+mB+XC4yW+w0a?=
 =?us-ascii?Q?/R/S9K2ykty+cXtSZcS9iV9uLDqZyTRx/z+Ap+Gw0hx3oOsO93B91o135pOC?=
 =?us-ascii?Q?4cFOwS1gzEd78vH9k+w4mCLzzH7C7bFcxIlCKth6PaehkPrAZvu1kHUjBG5G?=
 =?us-ascii?Q?l9BbzJraix0MgXtL0I7chqj2xaK90hMxGEMJ0VaaNRcc7ym82cyxQUfsyPyx?=
 =?us-ascii?Q?PTd7HSPXFCBoQobntYyJ09BPcI2Z+bK6jJqO+GKXRsM7Npx4ogTxX+5bS1yT?=
 =?us-ascii?Q?bwLULf+p7xvY9sSOBZofEHaeuzwfwVUy2FmudDHhQsNnVICCE5vX5DRgVYq3?=
 =?us-ascii?Q?sVe+ejt7e3iiZDbi4QIUCb5Br7mCHUMNHHzqOxONDTyXuxWqoRoAgg2JyBw4?=
 =?us-ascii?Q?YoulY5xAQlz2IbtcQ6OL13KCZwX9VQtE4qg5tp471U8mR3M7k1azh7IyZ/sQ?=
 =?us-ascii?Q?u/i96qB99ufjWJhgxxV5BB5sx0Qcb2H8aZo8t5/2JZQ4CTwf1EEcJRUe76s+?=
 =?us-ascii?Q?0b5UsrqbqB3JMqanWDkUcOED9JZ5zY/6pq9JjGorQMsgSdFEg5PuJYpO1f+e?=
 =?us-ascii?Q?RI+FUcSMdDSZ3sCsay+Cn2PFStWFzWdf3/5se7SGW7b9EvoDQP3WCC2nAOAq?=
 =?us-ascii?Q?5qD5CVySwr38y+LRG6K8NkCkjvY2LLxOQ3dAhu/yuIzewUtOZvDWScT5Vol7?=
 =?us-ascii?Q?Ptu+F95YCwwI6QwzfyrPxHaFhmpboFcon7tlSsvzlAuPkqAMSqB3yo0kxq9O?=
 =?us-ascii?Q?wmuspjtCTNyacYWFQE6Ix01CZosPo2dAyu9aFYTp9M8pDj3bEVFE60cZX69o?=
 =?us-ascii?Q?QpIhKbLqHftbzxUUD0tKon+InYHT2gmx4J7rT1TdmTK6l8cke5+Eml6LBGlx?=
 =?us-ascii?Q?U1UosCcstIVLUyj//rc+aDybrYPHo0IGwJIJAxsESFwNrXMHCY6rhObuq73Y?=
 =?us-ascii?Q?3FGU9hrrNvm+/gOedCnypXdN4L5vCW3eXDjzSDdLuHKTTrAbkdtiSgmIf2VF?=
 =?us-ascii?Q?hdKqt3mFVww7WoUGCmX7Z0SJzu9TYfRzZ4QZ+X4+NoMFc2m8ylZDl5sIzR6N?=
 =?us-ascii?Q?0wQn1dhaj3ZerkZ8EIZkdqVI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb371585-84af-49c7-b1e2-08d960b9f7dc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:30:09.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01vy6g1ffaICkNNVETAdf4yMmmzJ8gw7OTfnHgzRm9atF24c52AkOcizC/0YEZCe0B/p1MKfrhxa3uvcTrRkzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Create the Mirror VM and share the primary VM's encryption context
with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 accel/kvm/kvm-all.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f14b33dde1..624d1f779e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -369,9 +369,17 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
         if (ret < 0) {
             goto err;
         }
+        ret = kvm_mirror_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+        if (ret < 0) {
+            goto err;
+        }
     }
     mem.memory_size = slot->memory_size;
     ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+    if (ret < 0) {
+        goto err;
+    }
+    ret = kvm_mirror_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
     slot->old_flags = mem.flags;
 err:
     trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
@@ -2606,11 +2614,33 @@ static int kvm_init(MachineState *ms)
 
     kvm_state = s;
 
+    if (ms->smp.mirror_vcpus) {
+        do {
+            ret = kvm_ioctl(s, KVM_CREATE_VM, type);
+        } while (ret == -EINTR);
+
+        if (ret < 0) {
+            fprintf(stderr, "ioctl(KVM_CREATE_VM mirror vm) failed: %d %s\n",
+                    -ret, strerror(-ret));
+            goto err;
+        }
+        s->mirror_vm_fd = ret;
+    }
+
     ret = kvm_arch_init(ms, s);
     if (ret < 0) {
         goto err;
     }
 
+    if (s->mirror_vm_fd &&
+        kvm_vm_check_extension(s, KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
+        ret = kvm_mirror_vm_enable_cap(s, KVM_CAP_VM_COPY_ENC_CONTEXT_FROM,
+                                       0, s->vmfd);
+        if (ret < 0) {
+            goto err;
+        }
+    }
+
     if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
         s->kernel_irqchip_split = mc->default_kernel_irqchip_split ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
     }
-- 
2.17.1

