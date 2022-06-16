Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5B54D8BF
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 05:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357004AbiFPDEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 23:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355476AbiFPDEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 23:04:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4D95908A;
        Wed, 15 Jun 2022 20:04:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0sXkdSKNHqHifEo+LWePNdOmlc4OpdLXVirFFbk5zimPYuODFVbl/hDGymzKb6DN991XPwGj0W1UaOUIMp8ILGg1+8skNOYXCNoHmNccLWdNm+jCwI++KTv2GvFxzx7sqIA2381fiU6eFSl0hAJo/QT/OFCpgEqwMt4OOzuXKawjCZj0uivrt6rOvcyGCpBLX5FeC8Vbjkm93iyXzxfspBzhQixn5Xt54WALxv3Uoe0N+zSpzUnkJftM020Q5m0lrPpHDZFD1F0Kg9uqZCIjC9+w0HCKU3F6GkXNicu7Y8EP3KbBp/97tKw6aosIhfLAENySf6/X23dhnOXXA2LWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfP9l6G5FL1LZegV9so6/GpJhtJyB8mB/ArmDvEvAjg=;
 b=dcr8JcaEeKjvZ5sbAxh7+3a2gUQ42b+RG9fnAtJ0/98Ny/dbErSvOQQ1sYmQRXIKfNI/Gv81cvvIMvNbOzG+m+Fn3nn3ReFrQ7squ4zubF5KlWL7qkaKbMwOJKPC5t03f3zx14GoYGn5pu7snVDlNMfxQd7vynuxM7kJ6bbMzDkGTF0OU5AWv3L2WfA5Zu+NaJjotsDP7y4TAuc4X5+eG6yIUIEKePtbqsHGidTDCf/hSLuqieQrJHc4ywAAODDJ/jWJ+oYgjP4RMgwaPu38ZLYnwS7FrG0a/dJbk30ah5LQ3rgL2nNXDQ5cVR4+W2n8EdnfN99g2r1xhmvbRAsBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfP9l6G5FL1LZegV9so6/GpJhtJyB8mB/ArmDvEvAjg=;
 b=cUnMxnIH/UfKnuMP9ZCp8rq4gRAMT7qwtANU6pxO/BJwxEDwHRek8nccjF8Vz4vSiB55jE6/Fpjc7Dqvj19fZEpZw3dvsQ1fAT43LsbReghGcOW6Gm0F7QTA3UKIJsW3kLB6pa/noiO8k2G5Svzl2Fx2eZcVTndrfFPg3AU3z3KLIwlfEncQiyxJ3vFspJbJ2bVraMsoHerE2JBb/+vCpxYT+bzlI/+GyP6crNTuA89ckc72JRe9rbuGH4KSYAT6YUm7PEWGIH+fyVvT7bFbArF/XnGbDp7gZof9G+EsOhJ1JQJFxD9S5FTsgZymdjwVpu0oOtV2OzFfa4MgnLKF8g==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by BN7PR12MB2706.namprd12.prod.outlook.com (2603:10b6:408:2a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Thu, 16 Jun
 2022 03:04:47 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::d450:aced:134c:78ae]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::d450:aced:134c:78ae%5]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 03:04:47 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v3 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Topic: [RFC PATCH v3 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Index: AQHYgFWwvdrkrbsQaE2sq/2oISh1Wa1PwqgAgAGWquA=
Date:   Thu, 16 Jun 2022 03:04:46 +0000
Message-ID: <DM6PR12MB3500F2EB5DA46DEE00CCFCE4CAAC9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-6-kechenl@nvidia.com> <20220615024311.GA7808@gao-cwp>
In-Reply-To: <20220615024311.GA7808@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb37f2ff-cd31-4ffc-3997-08da4f44f86c
x-ms-traffictypediagnostic: BN7PR12MB2706:EE_
x-microsoft-antispam-prvs: <BN7PR12MB2706B0FDA5D7CDF5566326ECCAAC9@BN7PR12MB2706.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IUZ8XFHnWKjh0MALVj4noWUpU6FGRN6iYGhudLpMeJjE2la1QUGDOiosDjPo4lUb+qJsHhrqvZf+YCcqH29WGOItfgKuZxS/yj7SStxZldi9TjSAHnkWNRhezlCRsDOpRYyjfUKi4m2motFXHKYWqHT00jZaij4Vgs65R8ktl7hA98Nk1b8fYEW3eLbRYv7cHSdAvMOHMtIECRgxvUAhAeeHvcEj9mjEjbmIf+x7dLcajIib4pJeR/B1/OSoa8ewobnARsurZ41qz3+FgA5X/x/c3lhuRWH9AnPM2+93xRTjK4wemlX7U4rYVa6PW37CcHwr37wTEOkz02pd+vRSMCVcVCpBsP0ZxezzGWwL5h2phn67OZi7xx0mzqTSe7qmrIiGpxD6WdJGKXxXXn1OyzpdkEs1R570NNK7z88CkwiZq6Ey73swq7snGmtM8A5xNSEAhZNl3vbOpi1Q8b4lx/vids4GHMi+Bb9jnmOK7D8Iwui0GTteO34i8iqkvPb5IFj37OYJcodR5m/BQ0NZz+DdTkg3w4b2Jgds3jx3Br4KOX+vvHuuXwRy992VkTMQJ6feMbJTpQySubIGHDClKPT9emLehAPbqn8vPHlWOEvboTqhI3YyQAMhBCOQMth5MtGz/OxEZH7mtDz3xDYtL15G3lTwp5VL3+l3SLSVem78IBn5LGny9b5LFUOR0pbVIf2TcG1zdxrDlUigNWk1WOm8EzHcAUrEls9WNbxhCgM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(9686003)(6506007)(53546011)(7696005)(26005)(186003)(5660300002)(2906002)(33656002)(55016003)(52536014)(8936002)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(66946007)(76116006)(122000001)(71200400001)(38070700005)(38100700002)(54906003)(6916009)(508600001)(86362001)(316002)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?77L29wQQmLWV2P7mIpAse8fd8BGVTqBAKWkhPUdTkUz5zdMlZUp1M/I8Zj3W?=
 =?us-ascii?Q?Cz5MBbOvfJ58nmuljcaEOdCCmkUOnLjRF620hol3TEzrCs6UI/nHX4bk3Hxz?=
 =?us-ascii?Q?N4CC8hx2ypJplwBEnI6CKt9fQdq1ys6/3aaRJzTOLObWBoGUbAvmGJKPC9l2?=
 =?us-ascii?Q?8SabuQQRcEWRv2kmJWXEl9D6QoeZxgm+nbACjS7zbYXDjNoEFFy8WzVg41ll?=
 =?us-ascii?Q?x9lO5q+fr/yGgysUdx/PVYCmr6zRyXIwFw0jhtV87vZjKg3vzsocE6Pwr7K5?=
 =?us-ascii?Q?ZmgGEtxeWjV2uxpk9UFNNz+KAcREKKeI7ztU6yB+cMF7c8OphO4j0nUj9bbF?=
 =?us-ascii?Q?caNeWwDPog2mNRy+D4ZimqcMMqaOUnzk25XL4acyiYgmzIB0N06QDkGuU6g4?=
 =?us-ascii?Q?3lHKaYS6+0CaBAi+v+Ef8R/8RewjkCiFtA3ki5dALdv6NDSinWwpK9AFsUPT?=
 =?us-ascii?Q?EvsE8KXp0ycI45wIunUMrZQbjHOI2Njv5SZPDFr6qKc963bK/dgsdNzOXtS0?=
 =?us-ascii?Q?318o7bdcRHSt2dhCaVM4LXHttR1/Br/4RBbddNjR6BJnDaz+NIkohwP/6lej?=
 =?us-ascii?Q?zow0M4AKVtM2BioMlJTK/iJtF9tGV+l/2+o5LPMPbJqMeMcfE3ujvr0dp4/E?=
 =?us-ascii?Q?FqXLGd/KaxetTavtqOMOMumnFfiSjiPOnUWOE+pSlE7S77aAOnJ/lU3y6Y9w?=
 =?us-ascii?Q?KuB1dLizPIgPrs3sWh3XsAgaeGR02riia7FizqP11Lnc64FdA4g1X5jAXZ6C?=
 =?us-ascii?Q?Bs3HVgruQIcI9ivDMxasGe/d3wAvxw2omzj3RTZLgTlg0hPInzS9wOg9uXfV?=
 =?us-ascii?Q?X3kQX/+hWny+z6Ptb3cytEcW/dt+o76jSMvaUmYDFHwdi9f1qIm/r4d2A5Af?=
 =?us-ascii?Q?76quZP+IXAUVd/Z709omlEu7+11O35SV5ulniNJxEw+Skd94IVWgSf2ZuYSS?=
 =?us-ascii?Q?bZBZvPgtmJgbNM/bGqdUnzDOoiuG2M67Wtwk07Cyt7fKpLV6QUmUOhThApks?=
 =?us-ascii?Q?oIbtTYdPZotJsCJKucwSrOGt7mQWkVSUpqzTauhnwI0dbW2cC06qtBkp34rv?=
 =?us-ascii?Q?TrBhamNED861UjuWMvihSpOEyQjVwUrOuugywjQeBjq4msXqIKBRbXb+vFak?=
 =?us-ascii?Q?oYMk6S4aVctLTmKc6hNoYyZM7NjP1ysjgpHofLA/K8blN7fye/e+b3eWUO9l?=
 =?us-ascii?Q?q+GaeYd5SXrBaIaUxKtsFpUchxIEaf7I7PqqfbWztmJrYhTwTi/vAhjFmcR/?=
 =?us-ascii?Q?RzhiepoUot6QiyLnYqvq+G4Mf23q5xOxmrX0xv/wbgp7t3kp2j+dzOZY/WDO?=
 =?us-ascii?Q?KYuLfvap1YUO8WR7moJpFP+tSePbGrCutGCd62y9n/NAZCfqTgaxkamslNDj?=
 =?us-ascii?Q?uz1p4cYBM0MZGPFYqsdcnU93P+BNdiNcFcPpE9aXC1S5kzEBAsFEci/KoDfh?=
 =?us-ascii?Q?bltCHdZNbTdu9dWJYAVS6C7A0HemWwyNyUo1HHPop+GtRHfQx7P5s4Bacvhp?=
 =?us-ascii?Q?i+8GsB+2UePEfd9JU1+L23Kj5UfsG9G5U9aHpDysjoV6m/30UinVPUX3YwQH?=
 =?us-ascii?Q?IdxYNLz6B+RCOBLXHdPJB26sMP5lkqjZrk02VA0pMY1f6SzePd/xM2uXXOdr?=
 =?us-ascii?Q?ffFO/hrsl9rzu8v/IPuAHx2bqK7gyv8RxhIQTHMCrYft7SyoFjMVgjd7uZE1?=
 =?us-ascii?Q?sx12qfMlqm2O6F1MJ/d3YCAvgApLcqGa20RNKGVBvP9NbmV9F1v+YXPdRDm5?=
 =?us-ascii?Q?oGldsX6Avg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb37f2ff-cd31-4ffc-3997-08da4f44f86c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 03:04:46.9934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EykVc37q7TUvtUs/reU6zsXR6HPCBMpdWvCOhAz0xMeSKpZr20z/o9easbPnzOEmOucMeRlUmfNTLIG4T9r7VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2706
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Chao Gao <chao.gao@intel.com>
> Sent: Tuesday, June 14, 2022 7:43 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; seanjc@google.com;
> vkuznets@redhat.com; Somdutta Roy <somduttar@nvidia.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v3 5/7] KVM: x86: add vCPU scoped toggling for
> disabled exits
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> >@@ -5980,6 +5987,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct
> >kvm_irq_level *irq_event,  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                           struct kvm_enable_cap *cap)  {
> >+      struct kvm_vcpu *vcpu;
> >+      unsigned long i;
> >       int r;
> >
> >       if (cap->flags)
> >@@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm
> *kvm,
> >                       break;
> >
> >               mutex_lock(&kvm->lock);
> >-              if (kvm->created_vcpus)
> >-                      goto disable_exits_unlock;
> >+              if (kvm->created_vcpus) {
> >+                      kvm_for_each_vcpu(i, vcpu, kvm) {
> >+                              kvm_ioctl_disable_exits(vcpu->arch, cap->=
args[0]);
> >+
> >+ static_call(kvm_x86_update_disabled_exits)(vcpu);
>=20
> IMO, this won't work on Intel platforms. Because, to manipulate a vCPU's
> VMCS, vcpu_load() should be invoked in advance to load the VMCS.
> Alternatively, you can add a request KVM_REQ_XXX and defer updating
> VMCS to the next vCPU entry.
>=20

I see. Then adding a KVM request for VM-scoped exits toggling case on vmcs =
bits updating makes sense.=20
Thanks for the suggestion.

BR,
Kechen
> >+                      }
> >+              }
> >+              mutex_unlock(&kvm->lock);
> >
> >               kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
> >
> >               r =3D 0;
> >-disable_exits_unlock:
> >-              mutex_unlock(&kvm->lock);
> >               break;
> >       case KVM_CAP_MSR_PLATFORM_INFO:
> >               kvm->arch.guest_can_read_msr_platform_info =3D
> >cap->args[0];
> >--
> >2.32.0
> >
